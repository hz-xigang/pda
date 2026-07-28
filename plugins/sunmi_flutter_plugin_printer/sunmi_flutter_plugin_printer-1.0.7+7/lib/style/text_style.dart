import 'package:json_annotation/json_annotation.dart';
import '../enum/align.dart' show Align;
import '../enum/render_color.dart' show RenderColor;
import '../enum/rotate.dart' show Rotate;
import '../format/text_format.dart' show TextFormat;

part 'text_style.g.dart';
/// 文本样式属性
@JsonSerializable(explicitToJson: true) // 启用嵌套序列化
class TextStyle {
  final TextFormat textFormat;
  /// JsonSerializable不能使用私有构造TextStyle._(this.textFormat);
  TextStyle(this.textFormat);

  factory TextStyle.fromJson(Map<String, dynamic> json) => _$TextStyleFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleToJson(this);

  /// 设置文本字体大小（依赖打印机的渲染支持）
  TextStyle setTextSize(int size) {
    textFormat.textSize = size;
    return this;
  }

  /// 设置打印文本的横向放大倍数
  TextStyle setTextWidthRatio(int ratio) {
    textFormat.textWidthRatio = ratio;
    return this;
  }

  /// 设置打印文本的纵向放大倍数
  TextStyle setTextHeightRatio(int ratio) {
    textFormat.textHeightRatio = ratio;
    return this;
  }

  /// 设置文本两边的间距
  TextStyle setTextSpace(int space) {
    textFormat.textSpace = space;
    return this;
  }

  /// 设置下划线开关
  TextStyle enableUnderline(bool enable) {
    textFormat.enUnderline = enable;
    return this;
  }

  /// 设置删除线
  TextStyle enableStrikethrough(bool enable) {
    textFormat.enStrikethrough = enable;
    return this;
  }

  /// 设置斜体
  TextStyle enableItalics(bool enable) {
    textFormat.enItalics = enable;
    return this;
  }

  /// 文本倒置
  TextStyle enableInvert(bool enable) {
    textFormat.enInvert = enable;
    return this;
  }

  /// 文本反显
  TextStyle enableAntiColor(bool enable) {
    textFormat.enAntiColor = enable;
    return this;
  }

  /// 文本加粗
  TextStyle enableBold(bool enable) {
    textFormat.enBold = enable;
    return this;
  }

  /// 行打印中设置文本内容相对位置
  TextStyle setPosX(int offset) {
    textFormat.xOffset = offset;
    return this;
  }

  /// 行打印设置无效
  TextStyle setPosY(int offset) {
    textFormat.yOffset = offset;
    return this;
  }

  /// 行打印设置无效
  TextStyle setWidth(int width) {
    textFormat.width = width;
    return this;
  }

  /// 行打印设置无效
  TextStyle setHeight(int height) {
    textFormat.height = height;
    return this;
  }

  /// 行打印仅针对表格时的相对位置
  TextStyle setAlign(Align align) {
    textFormat.align = align.index;
    return this;
  }

  /// 行打印设置无效
  TextStyle setRotate(Rotate rotate) {
    textFormat.rotate = rotate.index;
    return this;
  }

  /// 设置自定义字体
  TextStyle setFont(String customFont) {
    textFormat.customFont = customFont;
    return this;
  }

  /// 设置字体的颜色
  TextStyle setRenderColor(RenderColor renderColor) {
    textFormat.renderColor = renderColor.index;
    return this;
  }

  /// 获取当前文本格式
  TextFormat format() {
    return textFormat;
  }

  /// 返回当前设置的样式属性对象
  static TextStyle getStyle() {
    return TextStyle(TextFormat(textSize: 24));
  }


}
