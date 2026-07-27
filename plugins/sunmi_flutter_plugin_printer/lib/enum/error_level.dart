enum ErrorLevel {
  L,
  M,
  Q,
  H,
}

/// 扩展 ErrorLevel 以添加 find 方法
extension ErrorLevelExtension on ErrorLevel {
  static ErrorLevel find(String value) {
    return ErrorLevel.values.firstWhere(
          (level) => level.name == value.toUpperCase(),
      orElse: () => ErrorLevel.L,
    );
  }
}
