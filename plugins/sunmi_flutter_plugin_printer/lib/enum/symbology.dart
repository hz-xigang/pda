enum Symbology {
  UPCA(0, "UPCA"),
  UPCE(1, "UPCE"),
  EAN13(2, "EAN13"),
  EAN8(3, "EAN8"),
  CODE39(4, "39"),
  ITF(5, "25"),
  CODABAR(6, "CODA"),
  CODE93(7, "93"),
  CODE128(8, "128M"),
  EAN128(9, "EAN128"),
  CODE128A(10, "128"),
  ITF_C(11, "25C"),
  CODE39_S(12, "39S"),
  CODE39_C(13, "39C"),
  EAN13_2(14, "EAN13+2"),
  UPCA_2(15, "UPCA+2"),
  UPCA_5(16, "UPCA+5"),
  EAN13_5(17, "EAN13+5"),
  EAN8_2(18, "EAN8+2"),
  EAN8_5(19, "EAN8+5"),
  UPCE_2(20, "UPCE+2"),
  UPCE_5(21, "UPCE+5");

  final int code;
  final String name;

  const Symbology(this.code, this.name);
}

// 扩展 SymbologyEnum
extension SymbologyExtension on Symbology {
  static String valueOf(int code) {
    for (var symbology in Symbology.values) {
      if (symbology.code == code) {
        return symbology.name;
      }
    }
    return ""; // 如果没有找到，返回空字符串
  }
}
