import 'dart:convert';

import 'package:flutter/services.dart';
import '../../enum/dividing_line.dart';
import '../../enum/printer_info.dart';
import '../../enum/setting_item.dart';
import '../../listener/printer_listener.dart';
import '../../style/area_style.dart';
import '../../style/barcode_style.dart';
import '../../style/base_style.dart';
import '../../style/bitmap_style.dart';
import '../../style/label_style.dart';
import '../../style/qr_style.dart';
import '../../style/text_style.dart';

import '../bean/printer.dart';
import '../common/constants.dart';
import '../common/global_utils.dart';
import '../common/param_constants.dart' show ParamConstants;
import '../interface/my_plugin_platform_interface.dart';

class MyPluginPlatformImpl implements MyPluginPlatformInterface {
  static MyPluginPlatformImpl get instance => _instance;

  final _methodChannel = const MethodChannel(Constants.METHOD_CHANNEL);
  final _eventChannel = const EventChannel(Constants.EVENT_CHANNEL_NAME);

  // 私有构造函数
  MyPluginPlatformImpl._internal() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      GlobalUtils.logger.d("_eventChannel listen: $event");
    }, onDone: () {
      GlobalUtils.logger.d("_eventChannel onDone: ");
    });
  }

  // 私有的静态实例
  static final MyPluginPlatformImpl _instance =
      MyPluginPlatformImpl._internal();

  @override
  Future<String?> getMyFirstChannelTest() async {
    final firstChannel = await _methodChannel
        .invokeMethod<String>(Constants.METHOD_MY_FIRST_CHANNEL_TEST);
    return firstChannel;
  }

  @override
  Future<void> printTextTest() async {
    _methodChannel.invokeMethod<void>(Constants.METHOD_PRINT_TEXT_TEST);
  }

  @override
  Future<void> getPrinter(PrinterListener listener) async {
    var printerStr = await _methodChannel
        .invokeMethod<String>(Constants.METHOD_PRINT_GET_PRINTER);
    if (printerStr == null || printerStr.isEmpty) return;
    var printer = Printer.fromJson(jsonDecode(printerStr));
    listener.onDefPrinter(printer);
  }

  @override
  Future<void> log(bool enable, String? tag) async {
    _methodChannel.invokeMethod(Constants.METHOD_PRINT_LOG,
        {ParamConstants.ENABLE: enable, ParamConstants.TAG: tag});
  }

  @override
  Future<void> destroy() async {
    _methodChannel.invokeMethod(Constants.METHOD_PRINT_DESTROY);
  }

  @override
  Future<bool?> startSettings(SettingItem item) async {
    return await _methodChannel.invokeMethod(
        Constants.METHOD_PRINT_START_SETTING, item.name);
  }

  @override
  Future<int?> getStatus() async {
    return await _methodChannel
        .invokeMethod<int>(Constants.METHOD_QUERY_GET_STATUS);
  }

  @override
  Future<String?> getInfo(PrinterInfo info) async {
    return _methodChannel.invokeMethod(
        Constants.METHOD_QUERY_GET_INFO, info.name);
  }

  @override
  Future<void> sendEscCommand(Uint8List esc) async {
    _methodChannel.invokeMethod(Constants.METHOD_COMMAND_SEND_ESC, esc);
  }

  @override
  Future<void> sendTsplCommand(Uint8List tspl) async {
    _methodChannel.invokeMethod(Constants.METHOD_COMMAND_SEND_TSPL, tspl);
  }

  @override
  Future<void> addText(String text, TextStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_ADD_TEXT, {
      ParamConstants.TEXT: text,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> autoOut() async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_AUTO_OUT);
  }

  @override
  Future<void> enableTransMode(bool enable) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_ENABLE_TRANS_MODE,
        {ParamConstants.ENABLE: enable});
  }

  @override
  Future<void> initLine(BaseStyle format) async {
    _methodChannel.invokeMethod(
        Constants.METHOD_LINE_INIT_LINE, jsonEncode(format.toJson()));
  }

  @override
  Future<void> printBarCode(String code, BarcodeStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_BARCODE, {
      ParamConstants.TEXT: code,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> printBitmap(Uint8List bitmap, BitmapStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_BITMAP, {
      ParamConstants.BITMAP: bitmap,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> printDividingLine(DividingLine style, int offset) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_DIVIDING_LINE, {
      ParamConstants.OFFSET: offset,
      ParamConstants.STYLE: style.name
    });
  }

  @override
  Future<void> printQrCode(String code, QrStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_QRCODE, {
      ParamConstants.TEXT: code,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> printText(String text, TextStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_TEXT, {
      ParamConstants.TEXT: text,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> printTexts(
      List<String> text, List<int> colsWidthArr, List<TextStyle> styles) async {
    _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_TEXTS, {
      ParamConstants.TEXT_LIST: jsonEncode(text),
      ParamConstants.COLS_WIDTH_ARR_LIST: jsonEncode(colsWidthArr),
      ParamConstants.STYLE_LIST:
          jsonEncode(styles.map((e) => e.toJson()).toList())
    });
  }

  @override
  Future<Map<String, dynamic>> printTrans() async {
    var rr =
        await _methodChannel.invokeMethod(Constants.METHOD_LINE_PRINT_TRANS);
    // 显式转换
    Map<String, dynamic> result = Map<String, dynamic>.from(rr);
    return result;
  }

  @override
  Future<void> initCanvas(LabelStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_INIT_CANVAS,
        {ParamConstants.STYLE: jsonEncode(style.toJson())});
  }

  @override
  Future<Map<String, dynamic>> printCanvas(int count) async {
    var rr = await _methodChannel.invokeMethod(
        Constants.METHOD_CANVAS_PRINT_CANVAS, {ParamConstants.COUNT: count});
    // 显式转换
    Map<String, dynamic> result = Map<String, dynamic>.from(rr);
    return result;
  }

  @override
  Future<void> renderArea(AreaStyle format) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_RENDER_AREA,
        {ParamConstants.STYLE: jsonEncode(format.toJson())});
  }

  @override
  Future<void> renderBarCode(String code, BarcodeStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_RENDER_BARCODE, {
      ParamConstants.TEXT: code,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> renderBitmap(Uint8List bitmap, BitmapStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_RENDER_BITMAP, {
      ParamConstants.BITMAP: bitmap,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> renderQrCode(String text, QrStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_RENDER_QRCODE, {
      ParamConstants.TEXT: text,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<void> renderText(String text, TextStyle style) async {
    _methodChannel.invokeMethod(Constants.METHOD_CANVAS_RENDER_TEXT, {
      ParamConstants.TEXT: text,
      ParamConstants.STYLE: jsonEncode(style.toJson())
    });
  }

  @override
  Future<bool?> isOpen() async {
    return await _methodChannel
        .invokeMethod(Constants.METHOD_CASH_DRAWER_IS_OPEN);
  }

  @override
  Future<Map<String, dynamic>> open() async {
    try {
      var rr = await _methodChannel
          .invokeMethod(Constants.METHOD_CASH_DRAWER_TO_OPEN);
      // 显式转换
      Map<String, dynamic> result = Map<String, dynamic>.from(rr);
      return result;
    } on PlatformException catch (e) {
      return {ParamConstants.CODE: -1000001, ParamConstants.MSG: e.message};
    }
  }
}
