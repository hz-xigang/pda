import 'dart:typed_data';

import '../enum/dividing_line.dart' show DividingLine;
import '../listener/print_result.dart' show PrintResult;
import '../style/barcode_style.dart' show BarcodeStyle;
import '../style/base_style.dart' show BaseStyle;
import '../style/bitmap_style.dart';
import '../style/qr_style.dart' show QrStyle;
import '../style/text_style.dart' show TextStyle;

/// 行渲染接口
/// 构建普通的热敏小票样张使用行渲染接口（热敏打印机类型）
/// SdkException返回API调用异常如不支持此接口
/// RenderError回调API执行期间的异常如打印机无法处理
abstract class LineApi {

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
  Future<void> printTrans(PrintResult listener);
}
