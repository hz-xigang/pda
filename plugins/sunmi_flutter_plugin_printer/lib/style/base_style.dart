
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

import '../enum/align.dart' show Align;
import '../enum/render_color.dart' show RenderColor;
import '../format/format.dart' show Format;

part 'base_style.g.dart';

/// 基础样式属性
@JsonSerializable(explicitToJson: true)
class BaseStyle {
  final Format format;
  /// JsonSerializable不能使用私有构造
  BaseStyle(this.format);

  factory BaseStyle.fromJson(Map<String, dynamic> json) => _$BaseStyleFromJson(json);
  Map<String, dynamic> toJson() => _$BaseStyleToJson(this);

  /// 设置之后打印内容整体的对齐方式
  BaseStyle setAlign(Align align) {
    format.align = align.index;
    return this;
  }

  /// 设置打印区域宽
  BaseStyle setWidth(int width) {
    format.width = width;
    return this;
  }

  /// 设置打印区域高
  BaseStyle setHeight(int height) {
    format.height = height;
    return this;
  }

  /// 设置打印区域坐标位置
  BaseStyle setPosX(int offset) {
    format.xOffset = offset;
    return this;
  }

  /// 设置打印区域坐标位置
  BaseStyle setPosY(int offset) {
    format.yOffset = offset;
    return this;
  }

  /// 设置打印颜色
  BaseStyle setRenderColor(RenderColor renderColor) {
    format.renderColor = renderColor.index;
    return this;
  }

  /// 返回当前设置的样式属性对象
  static BaseStyle getStyle() {
    return BaseStyle(Format());
  }
}
