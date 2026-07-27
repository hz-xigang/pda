// CanvasApi 接口
import 'dart:typed_data' show Uint8List;

import '../../style/label_style.dart';

import '../listener/print_result.dart' show PrintResult;
import '../style/area_style.dart' show AreaStyle;
import '../style/barcode_style.dart' show BarcodeStyle;
import '../style/bitmap_style.dart' show BitmapStyle;
import '../style/qr_style.dart' show QrStyle;
import '../style/text_style.dart' show TextStyle;

/// 画布打印接口
/// 构建画布内容按画布区域打印(标签、黑标、针式类型打印机）
/// SdkException返回API调用异常如不支持此接口
/// RenderError回调API执行期间的异常如打印机无法处理
abstract class CanvasApi {
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
  Future<void> printCanvas(int count, PrintResult listener);
}
