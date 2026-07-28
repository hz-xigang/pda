import 'package:json_annotation/json_annotation.dart';

import '../enum/shape.dart' show Shape;
import '../format/area_format.dart' show AreaFormat;

part 'area_style.g.dart';

@JsonSerializable(explicitToJson: true)
class AreaStyle {
  final AreaFormat areaFormat;

  AreaStyle(this.areaFormat);

  factory AreaStyle.fromJson(Map<String, dynamic> json) =>
      _$AreaStyleFromJson(json);

  Map<String, dynamic> toJson() => _$AreaStyleToJson(this);

  // 设置图形样式
  AreaStyle setStyle(Shape shape) {
    areaFormat.style = shape.index; // 假设 Shape 是一个枚举
    return this;
  }

  // 设置图形的宽度
  AreaStyle setWidth(int width) {
    areaFormat.width = width;
    return this;
  }

  // 设置图形的高度
  AreaStyle setHeight(int height) {
    areaFormat.height = height;
    return this;
  }

  // 设置图形位置
  AreaStyle setPosX(int offset) {
    areaFormat.xOffset = offset;
    return this;
  }

  // 设置图形位置
  AreaStyle setPosY(int offset) {
    areaFormat.yOffset = offset;
    return this;
  }

  // 设置线段的终点X坐标
  AreaStyle setEndX(int x) {
    areaFormat.endX = x;
    return this;
  }

  // 设置线段的终点Y坐标
  AreaStyle setEndY(int y) {
    areaFormat.endY = y;
    return this;
  }

  // 设置描边大小
  AreaStyle setThick(int w) {
    areaFormat.thickness = w;
    return this;
  }

  // 返回 AreaFormat 对象
  AreaFormat format() {
    return areaFormat;
  }

  // 获取当前样式属性对象
  static AreaStyle getStyle() {
    return AreaStyle(AreaFormat(endX: 50, endY: 50, thickness: 1)
      ..width = 50
      ..height = 50);
  }
}
