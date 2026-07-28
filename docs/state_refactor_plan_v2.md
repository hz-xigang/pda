# BaseProdTagScanState 重构方案 v2

本文是 `state_refactor_plan.md` 的修订版。原方案的 6 个问题描述基本属实，但存在 3 处会静默改变
运行时行为的隐患、1 处未真正消除重复的改动、2 处定义不完整的改动。本文只保留经源码验证的结论，
并给出可直接执行的顺序。

原方案文件保留不动，作为对照。

---

## 一、与原方案的事实差异

### 1.1 已验证准确的部分

- 问题 1：`products` 确实在 3 处重复实现（`PalletState`、`BasePutawayState`、`DocumentOperationState`）。
- 问题 4：`initialScannedTags` / `useCache` 全仓库无任何调用方传值，确为死参数。
- 问题 6：`inbound_state.dart` 与 `return_inbound_state.dart` 的 `buildSpec` 实现一字不差。

### 1.2 需要修正的部分

**Scope 数量少数了 2 个。** 原方案列出 5 个，实际有 7 个结构同构的 `InheritedNotifier` 子类：

| Scope | 文件 |
|---|---|
| `PalletScope` | `lib/module_pallet/print/state/pallet_state.dart:86` |
| `DocumentOperationScope` | `lib/module_document_operation/state/document_operation_state.dart` |
| `InboundScope` | `lib/module_putaway/inbound/state/inbound_state.dart:58` |
| `MoveScope` | `lib/module_putaway/move/state/move_state.dart:57` |
| `ReturnInboundScope` | `lib/module_putaway/return_inbound/state/return_inbound_state.dart:58` |
| `CartonPrintScope` | `lib/module_carton/print/state/carton_print_state.dart:156`（原方案遗漏） |
| `TagDetailScope` | `lib/components/tag_item/state/tag_detail_state.dart:52`（原方案遗漏） |

`watch` / `read` 调用点共 35 处。

**`BasePutawayState` 的 `buildSpec` 抽象声明应删除而非保留。** 原方案表格写「保留抽象声明（已有）」。
经 analyzer 验证，在抽象类中重新声明父类已有具体实现的方法是合法的（无告警，子类仍继承到实现），
所以不会编译失败；但基类既然提供了默认实现，该抽象声明就失去意义，且会强制 `BasePutawayState`
的所有子类必须覆写，与「默认实现」的目的矛盾。应删除。

---

## 二、原方案的 3 个行为变更隐患

### 隐患 A：`PalletState` 空值文案与其他两处不同

```dart
name: firstTag.productCategory ?? '未知分类',
prodNo: firstTag.prodNo ?? '未知单号',
```

另外两处用的是 `'--'`。直接上移会让打托页的空值显示从「未知分类 / 未知单号」变为「--」。

**决策：统一为 `'--'`**，与其余两个模块及 `buildSpec` 的空值风格保持一致。这是有意的 UI 变更，
需在实施时向使用方确认。若不接受，则 `PalletState` 需覆写 `products`，本次上移收益归零。

### 隐患 B：数量取整语义存在 3 种不同实现（最易漏）

`ProdTag.qty` 的类型是 `double?`（`lib/entity/prod_tag.dart:31`）。当前三处实现：

| 位置 | 实现 | 语义 |
|---|---|---|
| `PalletState` | `fold<double>` 累加后 `.toInt()` | 先求和再截断 |
| `BasePutawayState` | `fold<int>((s,t) => s + (t.qty ?? 0).toInt())` | 逐条截断再求和 |
| `DocumentOperationState.totalCount` | `products.fold` 累加已截断的分组值 | 分组内截断后再求和 |

三个 `qty = 0.5` 的标签：前者得 1，后者得 0。原方案给的基类实现采用了「逐条截断」，
会静默改变打托页的合计数。

**决策：统一为「先按 double 累加，最后一次 `toInt()`」**，即保留 `PalletState` 的语义。理由是
求和后截断的累积误差最小，且合计数与各分组数之和能保持一致（逐条截断会导致 `totalCount`
不等于各 `item.count` 之和）。

### 隐患 C：`tagIdentity` 简化为 `tag.id ?? tag.tagNo ?? ''` 有空值塌缩风险

`ProdTag` 未重写 `==` / `hashCode`。`onScanProduct` 的查重仅在 `tag.id != null` 时生效，
因此 `id` 与 `tagNo` 均为空的标签可以共存于 `scannedTags`。一旦它们的 identity 都算作 `''`，
删除任意一条会连带删掉全部空值标签。

**决策：改用对象身份删除，彻底移除 `tagIdentity`。** 已验证 `TagDetailPage.loadTags` 只对
`scannedTags` 做 `where` 过滤、不产生拷贝，因此 `onDeleteSelected` 收到的就是 `scannedTags`
中的同一批实例，`identical` 判定成立。

---

## 三、修改方案

### 改动 1：删除死参数（风险最低，先做）

`useCache` 字段并非完全无用，它被 3 处守卫引用：`saveTags` 的 `if (!useCache) return;`、
`clearCachedTags` 的同样守卫、以及 3 个子类构造中的 `if (this.useCache) loadCachedTags();`。
原方案只说「构造简化为无参」，未交代字段和守卫的去向。

**决策：连字段一起删除。** 由于无人传 `false`，该字段恒为 `true`，3 处守卫都是死分支。

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 删除两个构造参数与 `useCache` 字段；删除 `saveTags` / `clearCachedTags` 中的守卫；`scannedTags` 初始化为 `<ProdTag>[]` |
| `lib/module_pallet/print/state/pallet_state.dart` | 构造改无参；`if (this.useCache)` 去掉，直接调 `loadCachedTags()` |
| `lib/module_document_operation/state/document_operation_state.dart` | 同上 |
| `lib/module_putaway/base/base_putaway_state.dart` | 同上 |
| `lib/module_putaway/inbound/state/inbound_state.dart` | 构造改无参 |
| `lib/module_putaway/move/state/move_state.dart` | 构造改无参 |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | 构造改无参 |

顺带修掉一处坏味道：原构造里的 `useCache: useCache` 是自我赋值，靠形参遮蔽才生效，
且子类中不得不写 `this.useCache` 来消歧义。删除后这些别扭写法一并消失。

---

### 改动 2：合并 `buildSpec`（风险最低，先做）

在 `BaseProdTagScanState` 提供默认实现，删除两个完全相同的覆写。

```dart
@protected
String buildSpec(ProdTag tag) =>
    '${tag.spec ?? '--'} | ${tag.inventoryCode ?? '--'}';
```

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 新增默认 `buildSpec` |
| `lib/module_putaway/base/base_putaway_state.dart` | 删除 `String buildSpec(ProdTag firstTag);` 抽象声明 |
| `lib/module_putaway/inbound/state/inbound_state.dart` | 删除 `buildSpec` 覆写 |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | 删除 `buildSpec` 覆写 |
| `lib/module_putaway/move/state/move_state.dart` | 保留覆写（有「原库位」前缀） |

---

### 改动 3：`products` / `totalCount` 上移基类

前置条件：隐患 A（文案统一为 `'--'`）与隐患 B（取整口径统一为「先累加后截断」）已确认。

**新增到 `lib/state/base_prod_tag_scan_state.dart`：**

```dart
List<PalletProductItem> get products {
  final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
  for (final ProdTag tag in scannedTags) {
    groups.putIfAbsent(tag.prodOrderId ?? 'unknown_po', () => <ProdTag>[]).add(tag);
  }

  return groups.entries.map((entry) {
    final List<ProdTag> tags = entry.value;
    final ProdTag firstTag = tags.first;
    return PalletProductItem(
      prodOrderId: entry.key,
      name: firstTag.productCategory ?? '--',
      prodNo: firstTag.prodNo ?? '--',
      spec: buildSpec(firstTag),
      count: _sumQty(tags),
      tags: tags,
    );
  }).toList(growable: false);
}

int get totalCount => _sumQty(scannedTags);

// qty 为 double?，先累加再截断，避免逐条截断的累积误差，
// 并保证 totalCount == 各分组 count 之和。
int _sumQty(List<ProdTag> tags) =>
    tags.fold<double>(0.0, (sum, tag) => sum + (tag.qty ?? 0.0)).toInt();
```

注意 `PalletState` 原先返回 `.toList()`（可增长），另两处返回 `.toList(growable: false)`。
统一为不可增长，调用方只做读取，已核对无 `add` / `remove` 操作。

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 新增 `products`、`totalCount`、`_sumQty`；导入 `pallet_product_item.dart` |
| `lib/module_pallet/print/state/pallet_state.dart` | 删除 `products`、`totalCount`（文案与取整随之变更） |
| `lib/module_document_operation/state/document_operation_state.dart` | 删除 `products`、`totalCount` |
| `lib/module_putaway/base/base_putaway_state.dart` | 删除 `products`、`totalCount`；保留 `currentStep` |

`currentStep` 不上移：`BasePutawayState` 恒为 `1`，`PalletState` 是 `scannedTags.isEmpty ? 1 : 2`，
而 `DocumentOperationState` 根本没有这个 getter（单据页无步骤指示器）。语义不同，保持现状。

---

### 改动 4：用对象身份替代 `tagIdentity`

原方案简化为 `tag.id ?? tag.tagNo ?? ''`，存在隐患 C 的空值塌缩。改为对象身份判定，
彻底删除 `tagIdentity`。

```dart
Future<void> removeTags(List<ProdTag> tagsToRemove) async {
  // ProdTag 未重写 ==，且 id/tagNo 都可能为空，按值去重会误删。
  // loadTags 只对 scannedTags 做过滤、不产生拷贝，故实例身份可靠。
  scannedTags = scannedTags
      .where((tag) => !tagsToRemove.any((removed) => identical(tag, removed)))
      .toList();
  await saveTags();
  notifyListeners();
}
```

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | `removeTags` 改用 `identical`；删除 `tagIdentity` |

复杂度从 O(n) 升为 O(n·m)，但 m 是单次勾选的条码数、n 是已扫列表长度，PDA 场景下均为数十量级，
可忽略。若后续列表规模变大，可改用 `Set` 配合 `identityHashCode` 包装。

链路已验证：`TagDetailPage.loadTags` → `scannedTags.where(...)` → `TagDetailState.selectedTags`
按下标取原对象 → `onDeleteSelected`，全程未拷贝 `ProdTag`。

---

### 改动 5：Scope 抽泛型基类（替换原方案的改动 4）

原方案把 `watch` / `read` 合并为 `of(context, {listen})`，7 个类的样板一行没少，却要改 35 个
调用点，收益与风险不匹配。真正消除重复要抽泛型基类。

Dart 泛型是具化的，`dependOnInheritedWidgetOfExactType<NotifierScope<PalletState>>()` 能按
具体类型参数正确匹配，因此该方案可行。

**新增 `lib/state/notifier_scope.dart`：**

```dart
class NotifierScope<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const NotifierScope({super.key, required T notifier, required super.child})
      : super(notifier: notifier);

  static S watch<S extends ChangeNotifier>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NotifierScope<S>>();
    assert(scope != null, 'NotifierScope<$S> not found in context.');
    return scope!.notifier!;
  }

  static S read<S extends ChangeNotifier>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<NotifierScope<S>>();
    final scope = element?.widget as NotifierScope<S>?;
    assert(scope != null, 'NotifierScope<$S> not found in context.');
    return scope!.notifier!;
  }
}
```

各模块保留可读的别名，避免调用处出现裸泛型：

```dart
typedef PalletScope = NotifierScope<PalletState>;
```

**调用点写法：** `NotifierScope.watch<PalletState>(context)`。
`typedef` 无法承载静态方法，所以 35 个调用点仍需改写。若想零改动，可让各 Scope 保留薄壳类
继承 `NotifierScope<T>` 并各自留 4 行静态转发 —— 样板从 20 行降到 6 行，调用点不动。
两种取舍二选一，建议在实施时按团队对改动面的容忍度定。

涉及 7 个 Scope 定义文件 + 35 个调用点（含原方案遗漏的 `CartonPrintScope`、`TagDetailScope`）。

注意 `PalletProductList` 等文件在 `Navigator.push` 的新路由里重新包了一层 `PalletScope`
（因为新路由不在原 `InheritedWidget` 子树内），改写时这些构造点也要同步。

---

### 改动 6：页面复用 `BasePutawayPage`（最后做，需先补插槽）

原方案只说把 `locationSection` 改可选。对打托页够用，对单据页不够：

- `DocumentOperationPage` 没有步骤指示器，`stepIndicator` 也必须可选。
- 单据页在合计数之上还有「单据类型」和「单据选择」两个区块，而 `BasePutawayBody` 的
  `Column` 是固定顺序，没有可插入的位置。
- `PalletOperationPage` 有 `stepIndicator`，但滚动区内 `totalCount` 前没有 `SizedBox(height: 12)`，
  而 `BasePutawayBody` 有。这是 12px 的间距差异，属可接受的视觉统一。

**`BasePutawayBody` 需要的签名调整：**

```dart
const BasePutawayBody({
  super.key,
  this.stepIndicator,
  this.headerSections = const <Widget>[],
  required this.totalCount,
  required this.productList,
  this.locationSection,
  required this.confirmBar,
});

final Widget? stepIndicator;
final List<Widget> headerSections;
final Widget? locationSection;
```

`build` 内按需插入，`null` 与空列表时连同其间距一起省略。`headerSections` 放在滚动区顶部、
`totalCount` 之前，元素间自动插 16px 间距。

| 文件 | 操作 |
|---|---|
| `lib/module_putaway/base/base_putaway_page.dart` | `stepIndicator` / `locationSection` 改可选；新增 `headerSections` |
| `lib/module_pallet/print/index.dart` | 改用 `BasePutawayPage<PalletState>`，删除 `StatefulWidget` 实现 |
| `lib/module_document_operation/index.dart` | 改用 `BasePutawayPage<DocumentOperationState>`，删除 `StatefulWidget` 实现 |

两个页面的 `initState` / `dispose` 与 `BasePutawayPage` 完全同构（订阅 `PdaUtil().onScanResult`、
`dispose` 里 `cancel` + `dispose` notifier），替换后行为一致。

`BasePutawayPage` 已在 `dispose` 中调用 `_notifier.dispose()`，替换后不要在页面层重复 dispose。

---

## 四、执行顺序

按风险从低到高分 4 批，每批结束后跑 `flutter analyze`：

| 批次 | 内容 | 风险 | 前置条件 |
|---|---|---|---|
| 1 | 改动 1（删死参数）+ 改动 2（合并 `buildSpec`） | 低，纯删除 | 无 |
| 2 | 改动 4（对象身份删除） | 中，行为变更但方向明确 | 无 |
| 3 | 改动 3（`products` / `totalCount` 上移） | 中高，含 UI 与数值变更 | 隐患 A、B 的决策已确认 |
| 4 | 改动 5（Scope 泛型）+ 改动 6（页面复用） | 高，改动面大 | 改动 5 的两种取舍已选定 |

批次 1、2 之间无依赖，可合并提交。批次 3 必须在批次 2 之后，因为两者都改
`base_prod_tag_scan_state.dart`。批次 4 独立于前三批，可并行但建议最后做。

---

## 五、验证方式

仓库现有测试只有 `test/production_order_test.dart` 和 `test/widget_test.dart`，
覆盖不到本次涉及的任何状态类。批次 2 和 3 的行为变更无自动化兜底。

**建议先补 3 个单元测试再动批次 2、3**，成本低且正好锁住三个隐患：

1. `_sumQty`：3 个 `qty = 0.5` 的标签，断言 `totalCount == 1`（锁住隐患 B）。
2. `products` 分组：断言 `totalCount == products.map(count).sum`（锁住取整一致性）。
3. `removeTags`：两个 `id` 与 `tagNo` 均为 `null` 的标签，删其中一个，断言剩余长度为 1
   （锁住隐患 C）。

`BaseProdTagScanState` 是抽象类且构造中不触发网络请求，可在测试里建一个最小子类实现
`cacheKey` / `tagFlag`。注意 `saveTags` 会走 `ProgTagCacheProvider`，测试需初始化 Hive
或对该路径做隔离。

需人工回归的部分：

- 打托页合计数与产品卡片文案（隐患 A、B 的直接影响面）。
- 五个模块的标签详情页删除选中 / 删除全部。
- 批次 4 后，打托页与单据页的布局间距、扫码是否仍生效、返回后 notifier 是否正常释放。

