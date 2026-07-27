import '../cash_drawer_api.dart';
import '../../listener/print_result.dart';

import '../../common/param_constants.dart' show ParamConstants;
import '../../impl/my_plugin_platform_impl.dart' show MyPluginPlatformImpl;
import '../../interface/my_plugin_platform_interface.dart' show MyPluginPlatformInterface;

class CashDrawerApiImpl extends CashDrawerApi {
  CashDrawerApiImpl._internal();
  static final CashDrawerApiImpl _instance = CashDrawerApiImpl._internal();
  static CashDrawerApiImpl get instance => CashDrawerApiImpl._instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;

  @override
  Future<bool?> isOpen() async {
    return await _myPlugin.isOpen();
  }

  @override
  Future<void> open(PrintResult resultListener) async {
    var transRes = await _myPlugin.open();
    var code = transRes[ParamConstants.CODE] as int?;
    var msg = transRes[ParamConstants.MSG] as String?;
    resultListener.onResult(code, msg);
  }
  
}