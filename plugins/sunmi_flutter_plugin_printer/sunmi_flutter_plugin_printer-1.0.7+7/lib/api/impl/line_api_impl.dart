import 'dart:typed_data';

import '../line_api.dart';
import '../../common/param_constants.dart';
import '../../enum/dividing_line.dart';
import '../../listener/print_result.dart';
import '../../style/barcode_style.dart';
import '../../style/base_style.dart';
import '../../style/bitmap_style.dart';
import '../../style/qr_style.dart';
import '../../style/text_style.dart';

import '../../impl/my_plugin_platform_impl.dart' show MyPluginPlatformImpl;
import '../../interface/my_plugin_platform_interface.dart' show MyPluginPlatformInterface;

class LineApiImpl extends LineApi {
  LineApiImpl._internal();
  static final LineApiImpl _instance = LineApiImpl._internal();
  static LineApiImpl get instance => _instance;

  final MyPluginPlatformInterface _myPlugin = MyPluginPlatformImpl.instance;

  @override
  Future<void> addText(String text, TextStyle style) async {
    _myPlugin.addText(text, style);
  }

  @override
  Future<void> autoOut() async {
    _myPlugin.autoOut();
  }

  @override
  Future<void> enableTransMode(bool enable) async {
    _myPlugin.enableTransMode(enable);
  }

  @override
  Future<void> initLine(BaseStyle format) async {
    _myPlugin.initLine(format);
  }

  @override
  Future<void> printBarCode(String code, BarcodeStyle style) async {
    _myPlugin.printBarCode(code, style);
  }

  @override
  Future<void> printBitmap(Uint8List bitmap, BitmapStyle style) async {
    _myPlugin.printBitmap(bitmap, style);
  }

  @override
  Future<void> printDividingLine(DividingLine style, int offset) async {
    _myPlugin.printDividingLine(style, offset);
  }

  @override
  Future<void> printQrCode(String code, QrStyle style) async {
    _myPlugin.printQrCode(code, style);
  }

  @override
  Future<void> printText(String text, TextStyle style) async {
    _myPlugin.printText(text, style);
  }

  @override
  Future<void> printTexts(List<String> text, List<int> colsWidthArr, List<TextStyle> styles) async {
    _myPlugin.printTexts(text, colsWidthArr, styles);
  }

  @override
  Future<void> printTrans(PrintResult listener) async {
    var transRes = await _myPlugin.printTrans();
    var code = transRes[ParamConstants.CODE] as int?;
    var msg = transRes[ParamConstants.MSG] as String?;
    listener.onResult(code, msg);
  }


}