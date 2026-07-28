import '../enum/align.dart' show Align;
import '../enum/render_color.dart' show RenderColor;
import '../format/format.dart' show Format;
import '../format/label_format.dart' show LabelFormat;
import 'base_style.dart' show BaseStyle;


class LabelStyle extends BaseStyle {
  LabelFormat labelFormat;

  LabelStyle(this.labelFormat, Format format) : super(format);

  factory LabelStyle.fromJson(Map<String, dynamic> json) {
    return LabelStyle(
      LabelFormat.fromJson(json['labelFormat'] as Map<String, dynamic>),
      Format.fromJson(json['format'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'labelFormat': labelFormat.toJson(),
      'format': format.toJson(),
    };
  }

  /// 标签反向开关
  LabelStyle enableReverse(bool enable) {
    labelFormat.enableReverse = enable ? 1 : 2;
    return this;
  }

  /// 标签镜像开关
  LabelStyle enableMirror(bool enable) {
    labelFormat.enableMirror = enable ? 1 : 2;
    return this;
  }

  /// 标签回退开关
  LabelStyle enableBack(bool enable) {
    labelFormat.enableBack = enable ? 1 : 2;
    return this;
  }

  /// 标签进纸开关
  LabelStyle enableTear(bool enable) {
    labelFormat.enableTear = enable ? 1 : 2;
    return this;
  }

  @override
  LabelStyle setAlign(Align align) {
    super.setAlign(align);
    return this;
  }

  @override
  LabelStyle setWidth(int width) {
    super.setWidth(width);
    return this;
  }

  @override
  LabelStyle setHeight(int height) {
    super.setHeight(height);
    return this;
  }

  @override
  LabelStyle setPosX(int offset) {
    super.setPosX(offset);
    return this;
  }

  @override
  LabelStyle setPosY(int offset) {
    super.setPosY(offset);
    return this;
  }

  @override
  LabelStyle setRenderColor(RenderColor renderColor) {
    super.setRenderColor(renderColor);
    return this;
  }

  /// 返回当前设置的样式属性对象
  static LabelStyle getStyle() {
    return LabelStyle(LabelFormat(), Format());
  }
}
