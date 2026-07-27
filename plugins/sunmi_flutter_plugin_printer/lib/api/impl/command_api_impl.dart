import 'dart:typed_data';

import '../command_api.dart';

import '../../impl/my_plugin_platform_impl.dart';
import '../../interface/my_plugin_platform_interface.dart';

class CommandApiImpl extends CommandApi {
  /// 私有构造
  CommandApiImpl._internal();
  static final CommandApiImpl _instance = CommandApiImpl._internal();
  static CommandApiImpl get instance => _instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;


  @override
  Future<void> sendEscCommand(Uint8List esc) async {
    return await _myPlugin.sendEscCommand(esc);
  }

  @override
  Future<void> sendTsplCommand(Uint8List tspl) async {
    return await _myPlugin.sendTsplCommand(tspl);
  }

}