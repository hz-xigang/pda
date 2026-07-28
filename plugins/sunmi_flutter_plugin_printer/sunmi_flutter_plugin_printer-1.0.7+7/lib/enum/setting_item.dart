/// 打印设置项枚举
enum SettingItem {
  /// 打印机设置主页
  ALL,

  /// 打印机类型设置项
  TYPE,

  /// 打印机浓度设置项
  DENSITY,

  /// 80打印机纸张设置项
  PAPER,

  /// 打印机字体设置项
  FONT;

  static SettingItem find(String name) {
    return SettingItem.values.firstWhere(
      (item) => item.name == name,
      orElse: () => SettingItem.ALL,
    );
  }
}
