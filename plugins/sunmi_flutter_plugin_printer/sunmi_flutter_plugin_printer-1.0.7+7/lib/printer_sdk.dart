import '../../interface/my_plugin_platform_interface.dart';

import 'enum/setting_item.dart';
import 'impl/my_plugin_platform_impl.dart';
import 'listener/printer_listener.dart';

class PrinterSdk {
  PrinterSdk._internal();
  static final PrinterSdk _instance = PrinterSdk._internal();
  static PrinterSdk get instance => _instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;

  Future<String?> getMyFirstChannelTest() {
    return _myPlugin.getMyFirstChannelTest();
  }

  Future<void> printTextTest() {
    return _myPlugin.printTextTest();
  }

  /// 1.获取打印机
  Future<void> getPrinter(PrinterListener listener) {
    return _myPlugin.getPrinter(listener);
  }

  /// 2.设置接口日志输出
  Future<void> log(bool enable, String? tag) {
    return _myPlugin.log(enable, tag);
  }

  /// 3.释放SDK
  Future<void> destroy() {
    return _myPlugin.destroy();
  }

  /// 4.跳转打印机配置
  Future<bool?> startSettings(SettingItem item) {
    return _myPlugin.startSettings(item);
  }

}