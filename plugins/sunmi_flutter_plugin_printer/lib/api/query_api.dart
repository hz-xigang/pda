import '../enum/printer_info.dart' show PrinterInfo;
import '../enum/status.dart' show Status;

abstract class QueryApi {
  /// 获取指定打印机的状态返回
  /// @return 打印机状态 [Status]
  Future<Status> getStatus();

  /// 获取指定打印机的信息
  /// @param info 见 [PrinterInfo]
  /// @return 对应信息结果
  Future<String?> getInfo(PrinterInfo info);

  /// 获取指定打印机的参数
  /// @param param 见 [PrinterParam]
  /// @return 对应信息结果
  // int getParam(PrinterParam param);

  /// 获取打印机配件的信息
  /// @param info 见 [AccessoryInfo]
  /// @return 对应信息结果
  // String getAccessoryInfo(AccessoryInfo info);
}
