import 'dart:typed_data';

abstract class CommandApi {
  /// 向本地打印机发送 esc 指令
  ///
  /// @param esc   esc 指令字节流数据
  /// @throws SdkException 运行时异常
  Future<void> sendEscCommand(Uint8List esc);

  /// 向本地打印机发送 tspl 指令
  ///
  /// @param tspl   tspl 指令字节流数据
  /// @throws SdkException 运行时异常
  Future<void> sendTsplCommand(Uint8List tspl);
}