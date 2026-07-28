import 'package:json_annotation/json_annotation.dart';

import '../enum/align.dart';
import '../enum/image_algorithm.dart' show ImageAlgorithm;
import '../format/bitmap_format.dart';

part 'bitmap_style.g.dart';
/// 位图样式属性
@JsonSerializable(explicitToJson: true)
class BitmapStyle {
  final BitmapFormat bitmapFormat;
  /// JsonSerializable不能使用私有构造
  BitmapStyle(this.bitmapFormat);

  factory BitmapStyle.fromJson(Map<String, dynamic> json) => _$BitmapStyleFromJson(json);
  Map<String, dynamic> toJson() => _$BitmapStyleToJson(this);

  /// 设置渲染图片方式
  BitmapStyle setAlgorithm(ImageAlgorithm algorithm) {
    bitmapFormat.style = algorithm.index;
    return this;
  }

  /// 设置算法浮动值
  BitmapStyle setValue(int value) {
    bitmapFormat.value = value;
    return this;
  }

  /// 设置自定义宽度
  BitmapStyle setWidth(int width) {
    bitmapFormat.width = width;
    return this;
  }

  /// 设置自定义高度
  BitmapStyle setHeight(int height) {
    bitmapFormat.height = height;
    return this;
  }

  /// 设置相对前部分内容的位置（X坐标）
  BitmapStyle setPosX(int offset) {
    bitmapFormat.xOffset = offset;
    return this;
  }

  /// 设置图片内容的Y坐标
  BitmapStyle setPosY(int offset) {
    bitmapFormat.yOffset = offset;
    return this;
  }

  /// 设置基于一行的对齐方式
  BitmapStyle setAlign(Align align) {
    bitmapFormat.align = align.index;
    return this;
  }

  /// 获取当前的格式对象
  BitmapFormat format() {
    return bitmapFormat;
  }

  /// 返回当前设置的样式属性对象
  static BitmapStyle getStyle() {
    return BitmapStyle(BitmapFormat());
  }
}
