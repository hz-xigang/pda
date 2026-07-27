
/// 通用状态定义集合
/// 只返回影响打印机工作的状态
/// >0 非异常状态
/// 1000~1999   打印机报警状态
/// =0 准备就绪
/// <0 异常状态
/// -1000~-1009 紙張錯誤
/// -1010~-1019 過熱異常
/// -1020~-1029 開蓋異常
/// -1030~-1039 切刀異常
/// -1040~-1049 墨盒異常
/// -1050~-1059 雙打異常
/// -1060~-1069 紙盒異常
/// -1070~-1079 鼓組件異常
/// -1080~-1089 字車異常
///
enum Status {
  WARN_CARTRIDGE(1010),            // 墨盒即将用尽
  WARN_SPECIAL_PAPER(1003),        // 多功能纸盒纸将尽
  WARN_STANDARD_PAPER(1002),       // 标准纸盒纸将尽
  WARN_PICK_PAPER(1001),           // 打印纸待取纸
  WARN_THERMAL_PAPER(1000),        // 热敏打印纸将尽

  READY(0),                         // 准备就绪
  OFFLINE(-1),                      // 离线
  COMM(-2),                         // 通信异常
  UNKNOWN(-3),                      // 未知异常
  ERR_PAPER_OUT(-1000),            // 打印机缺纸中
  ERR_PAPER_JAM(-1001),            // 打印机堵纸中
  ERR_PAPER_MISMATCH(-1002),       // 打印纸不匹配设备
  ERR_PRINTER_HOT(-1010),          // 打印机打印头过热
  ERR_MOTOR_HOT(-1011),            // 打印机马达过热
  ERR_COVER(-1020),                // 开盖异常
  ERR_COVER_INCOMPLETE(-1021),     // 合盖不充分
  ERR_CUTTER(-1030),               // 切刀异常
  ERR_CARTRIDGE_LOSS(-1040),       // 未安装粉盒
  ERR_CARTRIDGE_MISMATCH(-1041),   // 粉盒不匹配
  ERR_CARTRIDGE_EMPTY(-1042),      // 粉盒用尽
  ERR_DUPLEX_LOSS(-1050),          // 双面单元未安装
  ERR_CARTON_LOSS(-1060),          // 纸盒未安装
  ERR_CARTON_MISMATCH(-1061),      // 纸盒不匹配
  ERR_CARTON_EMPTY(-1062),         // 纸盒缺纸
  ERR_DRUM_LOSS(-1070),            // 未安装鼓组件
  ERR_DRUM_MISMATCH(-1071),        // 鼓组件不匹配
  ERR_DRUM_EMPTY(-1072),           // 鼓组件用尽
  ERR_STEP(-1080);                 // 字车移动失步故障

  final int code;

  const Status(this.code);

  static Status valueOf(int errCode) {
    return Status.values.firstWhere(
          (status) => status.code == errCode,
      orElse: () => Status.UNKNOWN,
    );
  }
}
