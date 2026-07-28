import 'dart:typed_data';

import '../canvas_api.dart';
import '../../listener/print_result.dart';
import '../../style/area_style.dart';
import '../../style/barcode_style.dart';
import '../../style/bitmap_style.dart';
import '../../style/label_style.dart';
import '../../style/qr_style.dart';
import '../../style/text_style.dart';

import '../../common/param_constants.dart' show ParamConstants;
import '../../impl/my_plugin_platform_impl.dart' show MyPluginPlatformImpl;
import '../../interface/my_plugin_platform_interface.dart' show MyPluginPlatformInterface;

class CanvasApiImpl extends CanvasApi {
  CanvasApiImpl._internal();
  static final CanvasApiImpl _instance = CanvasApiImpl._internal();
  static CanvasApiImpl get instance => _instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;


  @override
  Future<void> initCanvas(LabelStyle style) async {
    _myPlugin.initCanvas(style);
  }

  @override
  Future<void> printCanvas(int count, PrintResult listener) async {
    var res = await _myPlugin.printCanvas(count);
    var code = res[ParamConstants.CODE] as int?;
    var msg = res[ParamConstants.MSG] as String?;
    listener.onResult(code, msg);
  }

  @override
  Future<void> renderArea(AreaStyle format) async {
    _myPlugin.renderArea(format);
  }

  @override
  Future<void> renderBarCode(String code, BarcodeStyle style) async {
    _myPlugin.renderBarCode(code, style);
  }

  @override
  Future<void> renderBitmap(Uint8List bitmap, BitmapStyle style) async {
    _myPlugin.renderBitmap(bitmap, style);
  }

  @override
  Future<void> renderQrCode(String text, QrStyle style) async {
    _myPlugin.renderQrCode(text, style);
  }

  @override
  Future<void> renderText(String text, TextStyle style) async {
    _myPlugin.renderText(text, style);
  }

}