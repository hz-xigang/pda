enum HumanReadable {
  HIDE,
  POS_ONE,
  POS_TWO,
  POS_THREE,
}

// 扩展 HumanReadableEnum
extension HumanReadableExtension on HumanReadable {
  // 静态方法：根据名称查找枚举值
  static HumanReadable find(String name) {
    return HumanReadable.values.firstWhere(
          (value) => value.name == name,
      orElse: () => HumanReadable.HIDE,
    );
  }
}
