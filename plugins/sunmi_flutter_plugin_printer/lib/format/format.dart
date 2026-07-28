import 'package:json_annotation/json_annotation.dart';
part 'format.g.dart';

@JsonSerializable(explicitToJson: true)
class Format {
  /// 在行打印中对应相对当前横向位置
  /// 在图打印中对应 x 轴坐标位置
  int xOffset;

  /// 在行打印中对应相对上一行的位置
  /// 在图打印中对应 y 轴坐标位置
  int yOffset;

  /// 预打印内容的宽度
  int width;

  /// 预打印内容的高度
  int height;

  /// 对齐方式
  int align;

  /// 旋转角度
  int rotate;

  /// 指定渲染的颜色
  int renderColor;

  Format({
    this.xOffset = 0,
    this.yOffset = 0,
    this.width = 0,
    this.height = 0,
    this.align = 0,
    this.rotate = 0,
    this.renderColor = 0,
  });

  factory Format.fromJson(Map<String, dynamic> json) => _$FormatFromJson(json);

  Map<String, dynamic> toJson() => _$FormatToJson(this);

}