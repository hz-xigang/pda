# module_putaway/base 抽取建议

## 目标

`module_putaway/inbound` 和 `module_putaway/move` 目前已经具备明显的同构结构，适合再下沉一层 `module_putaway/base`，把“页面骨架 + 状态基类 + 公共表单区块”抽出来，减少重复代码。

当前目的不是马上全量重构，而是先明确：

1. 哪些内容已经重复
2. 哪些内容适合抽到 `base`
3. 抽完之后大概能减少什么

---

## 当前重复点

### 1. 页面入口结构重复

`inbound/index.dart` 和 `move/index.dart` 基本一致：

- `StatefulWidget` + `StreamSubscription<String>`
- `initState()` 中创建状态对象
- 监听 `PdaUtil().onScanResult`
- `dispose()` 取消订阅并释放状态
- `Scaffold -> SafeArea -> Scope -> Padding -> Body`
- 页面主体布局都是：
  - 返回栏
  - 步骤条
  - 总件数
  - 产品列表
  - 库位区
  - 底部确认按钮

这部分完全可以抽成一个：

- `module_putaway/base/base_putaway_page.dart`
或者
- `module_putaway/base/base_putaway_body.dart`

让 `inbound` 和 `move` 只传：

- state
- 主题色
- 步骤文案
- 确认按钮文案

---

### 2. state 结构高度重复

`InboundState` 和 `MoveState` 现在都包含：

- 继承 `BaseProdTagScanState`
- `_locationOptions`
- `_selectedLocation`
- `initLocList()`
- `locationOptions / selectedLocation` getter
- `products` 分组映射
- `totalCount`
- `currentStep`
- `updateLocation()`
- 最后一个确认动作

当前已经抽掉了扫码与标签缓存基类，但 `putaway` 自己这一层仍然重复。

建议新增：

- `module_putaway/base/base_putaway_state.dart`

可抽公共内容：

- `_locationOptions`
- `_selectedLocation`
- `initLocList()`
- `locationOptions / selectedLocation / selectedLocationLabel`
- `updateLocation()`
- `products` 的基础分组逻辑
- `totalCount`
- `currentStep`

子类只保留：

- `cacheKey`
- `tagFlag`
- `spec` 如何拼接
- 确认动作调用哪个 API
- 成功提示文案

---

### 3. components 命名和结构重复

当前两组组件是：

#### inbound

- `inbound_confirm_bar.dart`
- `inbound_location_section.dart`
- `inbound_product_list.dart`
- `inbound_step_indicator.dart`
- `inbound_total_count.dart`

#### move

- `move_confirm_bar.dart`
- `move_location_section.dart`
- `move_product_list.dart`
- `move_step_indicator.dart`
- `move_total_count.dart`

其中：

- `product_list`
- `step_indicator`
- `total_count`
- `confirm_bar`

其实已经只是薄封装，真正逻辑都在公共组件里了。

还剩最值得往 `module_putaway/base/components` 抽的是：

- `location_section`

因为这两个文件现在几乎只有主题色和 state 类型差别。

建议新增：

- `module_putaway/base/components/base_putaway_location_section.dart`

让 `inbound` / `move` 只保留一层颜色和 state 适配。

---

### 4. 主题配置重复

两页本质上只是不同的视觉主题：

- `inbound`: `0xFF18A8F1`
- `move`: `0xFF00B894`

建议抽一个简单配置对象：

- `module_putaway/base/putaway_theme_config.dart`

例如包含：

- `primaryColor`
- `softColor`
- `stepSecondLabel`
- `confirmButtonText`
- `pageTitle`

这样页面和组件都不需要到处硬编码颜色。

---

## 建议抽取后的目录

```text
lib/module_putaway/
  base/
    base_putaway_page.dart
    base_putaway_state.dart
    putaway_theme_config.dart
    components/
      base_putaway_location_section.dart
  inbound/
    index.dart
    state/
      inbound_state.dart
  move/
    index.dart
    state/
      move_state.dart
```

---

## 预计能减少什么

### 可减少的重复代码类型

- 页面装配层重复
- 库位选择区重复
- 主题色散落
- putaway 状态层重复

### 直接收益

- `inbound/index.dart` 和 `move/index.dart` 会变成非常薄的入口文件
- 后面新增第三个页面，比如“退货上架 / 库位调整”，成本会明显降低
- 颜色、文案、按钮文本更容易统一维护
- state 结构更清晰，减少“两个文件同步改同一逻辑”的风险

---

## 我建议的抽取顺序

1. 先抽 `base_putaway_state.dart`
2. 再抽 `base_putaway_location_section.dart`
3. 最后抽 `base_putaway_page.dart`

原因：

- 状态层重复最高，先抽收益最大
- 库位区其次，改动风险低
- 页面骨架最后抽，避免一开始改动过大

---

## 当前结论

`module_putaway/base` 很值得建，而且现在时机是合适的。

因为：

- `inbound` 和 `move` 已经形成稳定同构
- 公共 workflow 组件已经抽出
- 剩下的重复主要集中在 putaway 业务层本身

如果继续执行，我建议下一步直接做：

`base_putaway_state.dart`

这是收益最高、风险最低的一步。
