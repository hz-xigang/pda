
import 'package:json_annotation/json_annotation.dart';

import '../enum/align.dart' show Align;
import '../enum/human_readable.dart' show HumanReadable;
import '../enum/rotate.dart' show Rotate;
import '../enum/symbology.dart' show Symbology;
import '../format/barcode_format.dart' show BarcodeFormat;
part 'barcode_style.g.dart';

/// 条形码样式属性
@JsonSerializable(explicitToJson: true)
class BarcodeStyle {
  final BarcodeFormat barcodeFormat;
  /// JsonSerializable不能使用私有构造
  BarcodeStyle(this.barcodeFormat);

  factory BarcodeStyle.fromJson(Map<String, dynamic> json) => _$BarcodeStyleFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeStyleToJson(this);

  /// 条形码码块宽度
  BarcodeStyle setDotWidth(int width) {
    barcodeFormat.dotWidth = width;
    return this;
  }

  /// 条形码码高度
  BarcodeStyle setBarHeight(int height) {
    barcodeFormat.barHeight = height;
    return this;
  }

  /// 人类可识读位置
  BarcodeStyle setReadable(HumanReadable readable) {
    barcodeFormat.readable = readable.index;
    return this;
  }

  /// 条码类型
  BarcodeStyle setSymbology(Symbology symbology) {
    barcodeFormat.symbology = symbology.code;
    return this;
  }

  /// 自定义宽度
  BarcodeStyle setWidth(int width) {
    barcodeFormat.width = width;
    return this;
  }

  /// 自定义高度
  BarcodeStyle setHeight(int height) {
    barcodeFormat.height = height;
    return this;
  }

  /// 设置条码内容的 x 坐标
  BarcodeStyle setPosX(int offset) {
    barcodeFormat.xOffset = offset;
    return this;
  }

  /// 设置条码内容的 y 坐标
  BarcodeStyle setPosY(int offset) {
    barcodeFormat.yOffset = offset;
    return this;
  }

  /// 指定条码相对坐标的对齐位置
  BarcodeStyle setAlign(Align align) {
    barcodeFormat.align = align.index;
    return this;
  }

  /// 指定条码旋转方向
  BarcodeStyle setRotate(Rotate rotate) {
    barcodeFormat.rotate = rotate.index;
    return this;
  }

  /// 返回当前的条形码格式
  BarcodeFormat format() {
    return barcodeFormat;
  }

  /// 返回当前设置的样式属性对象
  static BarcodeStyle getStyle() {
    return BarcodeStyle(BarcodeFormat(dotWidth: 2, barHeight: 162, symbology: 8));
  }
}
