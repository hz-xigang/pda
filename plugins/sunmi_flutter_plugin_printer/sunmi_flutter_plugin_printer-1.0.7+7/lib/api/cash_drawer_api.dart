import '../listener/print_result.dart' show PrintResult;

abstract class CashDrawerApi {
  /// 打开本地钱箱
  /// @param resultListener    钱箱开启情况，接口可执行后具体到调用打印机时的异常
  /// @throws SdkException     接口实现情况，除商米打印机外目前接口返回不支持异常
  Future<void> open(PrintResult resultListener);

  /// 返回本地钱箱的开启状态
  /// @return true 钱箱开启 false 钱箱未开启
  /// @throws SdkException     接口实现情况，除商米打印机外目前接口返回不支持
  Future<bool?> isOpen();
}
