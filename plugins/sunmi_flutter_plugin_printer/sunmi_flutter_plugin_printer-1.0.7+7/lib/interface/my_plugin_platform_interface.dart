import 'dart:typed_data';

import '../../enum/printer_info.dart';
import '../../style/label_style.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../enum/dividing_line.dart' show DividingLine;
import '../enum/setting_item.dart';
import '../listener/printer_listener.dart';
import '../style/area_style.dart' show AreaStyle;
import '../style/barcode_style.dart' show BarcodeStyle;
import '../style/base_style.dart' show BaseStyle;
import '../style/bitmap_style.dart' show BitmapStyle;
import '../style/qr_style.dart' show QrStyle;
import '../style/text_style.dart' show TextStyle;

abstract class MyPluginPlatformInterface extends PlatformInterface {
  MyPluginPlatformInterface({required super.token});
  Future<String?> getMyFirstChannelTest();
  Future<void> printTextTest();

  Future<void> getPrinter(PrinterListener listener);

  Future<void> log(bool enable, String? tag);

  Future<void> destroy();

  Future<bool?> startSettings(SettingItem item);

  Future<int?> getStatus();

  Future<String?> getInfo(PrinterInfo info);

  Future<void> sendEscCommand(Uint8List esc);

  Future<void> sendTsplCommand(Uint8List tspl);

  /// 初始化行样式
  Future<void> initLine(BaseStyle format);

  /// 在当前行追加方式渲染文本内容
  Future<void> addText(String text, TextStyle style);

  /// 在当前行渲染文本内容
  Future<void> printText(String text, TextStyle style);

  /// 在当前行渲染多列文本内容
  Future<void> printTexts(List<String> text, List<int> colsWidthArr, List<TextStyle> styles);

  /// 在当前行渲染条码
  Future<void> printBarCode(String code, BarcodeStyle style);

  /// 在当前行渲染二维码
  Future<void> printQrCode(String code, QrStyle style);

  /// 在当前行渲染位图
  Future<void> printBitmap(Uint8List bitmap, BitmapStyle style);

  /// 在当前行渲染分割线
  Future<void> printDividingLine(DividingLine style, int offset);

  /// 自动出纸
  Future<void> autoOut();

  /// 开启或关闭事务模式
  Future<void> enableTransMode(bool enable);

  /// 在事务模式下触发打印
  Future<Map<String, dynamic>> printTrans();

  /// 初始化画布.
  /// 指定打印标签的画布大小、基础格式
  Future<void> initCanvas(LabelStyle style);

  /// 在画布上绘制文本内容.
  Future<void> renderText(String text, TextStyle style);

  /// 在画布上绘制条形码.
  Future<void> renderBarCode(String code, BarcodeStyle style);

  /// 在画布上绘制二维码.
  Future<void> renderQrCode(String text, QrStyle style);

  /// 在画布上绘制位图.
  Future<void> renderBitmap(Uint8List bitmap, BitmapStyle style);

  /// 在画布上绘制图形.
  Future<void> renderArea(AreaStyle format);

  /// 开始打印画布内容
  Future<Map<String, dynamic>> printCanvas(int count);

  /// 打开本地钱箱
  /// @param resultListener    钱箱开启情况，接口可执行后具体到调用打印机时的异常
  /// @throws SdkException     接口实现情况，除商米打印机外目前接口返回不支持异常
  Future<Map<String, dynamic>> open();

  /// 返回本地钱箱的开启状态
  /// @return true 钱箱开启 false 钱箱未开启
  /// @throws SdkException     接口实现情况，除商米打印机外目前接口返回不支持
  Future<bool?> isOpen();
}