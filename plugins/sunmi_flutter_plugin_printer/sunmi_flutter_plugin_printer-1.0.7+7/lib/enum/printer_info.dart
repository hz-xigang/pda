///打印机信息枚举类
enum PrinterInfo {
  ID,        // 打印机序列号，由打印机厂商提供
  NAME,      // 打印机名称
  VERSION,   // 打印机固件版本号
  DISTANCE,  // 已打印距离
  CUTTER,    // 切刀使用次数
  HOT,       // 打印机过热次数统计
  DENSITY,   // 打印机浓度
  TYPE,      // 打印机种类
  PAPER,     // 打印机当前支持纸张类型
  GRAY,      // 打印机是否使用高级灰度打印
  NULL;      // 空值

  // 匹配对应的枚举类型
  static PrinterInfo findInfo(String info) {
    return PrinterInfo.values.firstWhere(
          (printerInfo) => printerInfo.toString().split('.').last == info,
      orElse: () => PrinterInfo.NULL,
    );
  }
}
