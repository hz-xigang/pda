# BaseProdTagScanState 重构方案

## 问题汇总

### 问题 1：`products` / `totalCount` 重复 3 次

`PalletState`、`DocumentOperationState`、`BasePutawayState` 各自实现了几乎相同的 `products` getter（约 15 行）和 `totalCount`。
`BasePutawayState` 已用 `buildSpec()` 抽象了 spec 差异，但该模式未上移到 `BaseProdTagScanState`，导致另外两个子类各自重写。

### 问题 2：Scope 样板代码重复 5 次

以下 5 个文件各自定义了结构完全相同的 `InheritedNotifier` 子类，仅类型名不同：

- `PalletScope`（pallet_state.dart）
- `DocumentOperationScope`（document_operation_state.dart）
- `InboundScope`（inbound_state.dart）
- `MoveScope`（move_state.dart）
- `ReturnInboundScope`（return_inbound_state.dart）

每个 Scope 约 20 行，`watch()` / `read()` 逻辑完全一致。

### 问题 3：页面生命周期代码重复

`PalletOperationPage` 和 `DocumentOperationPage` 各自手写了扫码订阅的 `initState` / `dispose`，
而 putaway 模块已通过 `BasePutawayPage<T>` 统一解决了这个问题。

### 问题 4：构造参数是死代码

`BaseProdTagScanState` 的 `initialScannedTags` 和 `useCache` 参数从未被任何调用方传值（全部使用无参构造），属于无效的灵活性设计。

### 问题 5：`tagIdentity` 过度设计

用 6 个字段拼接唯一标识，但 `tag.id` 本身已足够唯一，且该方法仅在 `removeTags` 中使用。

### 问题 6：`InboundState` 与 `ReturnInboundState` 的 `buildSpec` 完全相同

两个文件的 `buildSpec` 实现一字不差，可由基类提供默认实现。

---

## 修改方案

### 改动 1（高优先级）：`products` / `totalCount` / `buildSpec` 上移基类

**涉及文件：**

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 新增 `buildSpec()`、`products`、`totalCount` |
| `lib/module_pallet/print/state/pallet_state.dart` | 删除 `products`、`totalCount` |
| `lib/module_document_operation/state/document_operation_state.dart` | 删除 `products`、`totalCount` |
| `lib/module_putaway/base/base_putaway_state.dart` | 删除 `products`、`totalCount`，保留 `buildSpec()` 抽象声明（已有） |
| `lib/module_putaway/inbound/state/inbound_state.dart` | `buildSpec` 可删除（与基类默认实现相同） |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | `buildSpec` 可删除（与基类默认实现相同） |
| `lib/module_putaway/move/state/move_state.dart` | 保留 `buildSpec`（有额外的"原库位"前缀，与默认不同） |

**改动内容（base_prod_tag_scan_state.dart）：**

```dart
// 新增默认 buildSpec，子类可覆盖
@protected
String buildSpec(ProdTag tag) =>
    '${tag.spec ?? '--'} | ${tag.inventoryCode ?? '--'}';

// 上移 products getter
List<PalletProductItem> get products {
  final groups = <String, List<ProdTag>>{};
  for (final tag in scannedTags) {
    groups.putIfAbsent(tag.prodOrderId ?? 'unknown_po', () => []).add(tag);
  }
  return groups.entries.map((e) {
    final tags = e.value;
    final first = tags.first;
    return PalletProductItem(
      prodOrderId: e.key,
      name: first.productCategory ?? '--',
      prodNo: first.prodNo ?? '--',
      spec: buildSpec(first),
      count: tags.fold(0, (s, t) => s + (t.qty ?? 0).toInt()),
      tags: tags,
    );
  }).toList();
}

// 上移 totalCount
int get totalCount =>
    scannedTags.fold(0, (s, t) => s + (t.qty ?? 0).toInt());
```

---

### 改动 2（高优先级）：删除死参数

**涉及文件：**

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 删除 `initialScannedTags`、`useCache` 参数，构造简化为无参 |
| `lib/module_pallet/print/state/pallet_state.dart` | 删除透传参数 |
| `lib/module_document_operation/state/document_operation_state.dart` | 删除透传参数 |
| `lib/module_putaway/base/base_putaway_state.dart` | 删除透传参数 |
| `lib/module_putaway/inbound/state/inbound_state.dart` | 删除透传参数 |
| `lib/module_putaway/move/state/move_state.dart` | 删除透传参数 |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | 删除透传参数 |

---

### 改动 3（中优先级）：简化 `tagIdentity`

**涉及文件：**

| 文件 | 操作 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 简化为 `tag.id ?? tag.tagNo ?? ''` |

---

### 改动 4（中优先级）：Scope `watch` / `read` 合并为 `of()`

**涉及文件（各自修改）：**

| 文件 | 操作 |
|---|---|
| `lib/module_pallet/print/state/pallet_state.dart` | `watch`/`read` 合并为 `of(context, {bool listen = true})` |
| `lib/module_document_operation/state/document_operation_state.dart` | 同上 |
| `lib/module_putaway/inbound/state/inbound_state.dart` | 同上 |
| `lib/module_putaway/move/state/move_state.dart` | 同上 |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | 同上 |

同步更新所有调用 `.watch()` / `.read()` 的组件文件为 `.of(context)` / `.of(context, listen: false)`。

---

### 改动 5（低优先级）：`PalletPage` / `DocumentPage` 复用 `BasePutawayPage`

**涉及文件：**

| 文件 | 操作 |
|---|---|
| `lib/module_putaway/base/base_putaway_page.dart` | `BasePutawayBody.locationSection` 改为可选参数 |
| `lib/module_pallet/print/index.dart` | 改用 `BasePutawayPage<PalletState>`，删除 `StatefulWidget` 实现 |
| `lib/module_document_operation/index.dart` | 改用 `BasePutawayPage<DocumentOperationState>`，删除 `StatefulWidget` 实现 |

---

## 文件变更总览

| 文件 | 改动类型 |
|---|---|
| `lib/state/base_prod_tag_scan_state.dart` | 新增 `products`、`totalCount`、`buildSpec`；简化构造和 `tagIdentity` |
| `lib/module_pallet/print/state/pallet_state.dart` | 删除重复代码，简化 Scope |
| `lib/module_document_operation/state/document_operation_state.dart` | 删除重复代码，简化 Scope |
| `lib/module_putaway/base/base_putaway_state.dart` | 删除重复代码 |
| `lib/module_putaway/inbound/state/inbound_state.dart` | 删除 `buildSpec`（与基类默认相同），简化 Scope |
| `lib/module_putaway/move/state/move_state.dart` | 保留 `buildSpec`，简化 Scope |
| `lib/module_putaway/return_inbound/state/return_inbound_state.dart` | 删除 `buildSpec`（与基类默认相同），简化 Scope |
| `lib/module_putaway/base/base_putaway_page.dart` | `locationSection` 改可选（低优先级） |
| `lib/module_pallet/print/index.dart` | 改用 `BasePutawayPage`（低优先级） |
| `lib/module_document_operation/index.dart` | 改用 `BasePutawayPage`（低优先级） |
