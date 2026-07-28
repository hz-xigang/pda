enum DividingLine {
  EMPTY,
  SOLID,
  DOTTED,
}

extension DividingLineExtension on DividingLine {
  static DividingLine find(String value) {
    return DividingLine.values.firstWhere(
          (line) => line.toString().split('.').last == value,
      orElse: () => DividingLine.EMPTY,
    );
  }
}
