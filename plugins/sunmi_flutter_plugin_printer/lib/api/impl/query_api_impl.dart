import '../../api/query_api.dart';
import '../../enum/printer_info.dart';
import '../../enum/status.dart';

import '../../impl/my_plugin_platform_impl.dart';
import '../../interface/my_plugin_platform_interface.dart';

class QueryApiImpl extends QueryApi {
  /// 私有构造函数
  QueryApiImpl._internal();
  /// 私有静态实例
  static final QueryApiImpl _instance = QueryApiImpl._internal();
  /// 暴漏静态示例
  static QueryApiImpl get instance => _instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;

  @override
  Future<String?> getInfo(PrinterInfo info) async {
    return await _myPlugin.getInfo(info);
  }

  @override
  Future<Status> getStatus() async {
    var code = await _myPlugin.getStatus();
    return Status.valueOf(code ?? 99999);
  }

}