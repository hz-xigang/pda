import 'package:json_annotation/json_annotation.dart';

import 'format.dart'; // 假设 Format 类在 format.dart 文件中

part 'text_format.g.dart';
/// 文本格式设置
@JsonSerializable(explicitToJson: true)
class TextFormat extends Format {
  /// 文本尺寸大小
  int textSize;

  /// 横向放大比例
  int textWidthRatio;

  /// 纵向放大比例
  int textHeightRatio;

  /// 左右边距
  int textSpace;

  /// 下划线使能
  bool enUnderline;

  /// 删除线使能
  bool enStrikethrough;

  /// 倾斜使能
  bool enItalics;

  /// 文本倒置使能
  bool enInvert;

  /// 反色使能
  bool enAntiColor;

  /// 加粗使能
  bool enBold;

  /// 自定义字体
  String customFont;

  TextFormat({
    this.textSize = 0,
    this.textWidthRatio = 0,
    this.textHeightRatio = 0,
    this.textSpace = 0,
    this.enUnderline = false,
    this.enStrikethrough = false,
    this.enItalics = false,
    this.enInvert = false,
    this.enAntiColor = false,
    this.enBold = false,
    this.customFont = '',
  }) : super();

  /// 从 JSON 创建 TextFormat 实例
  factory TextFormat.fromJson(Map<String, dynamic> json) => _$TextFormatFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$TextFormatToJson(this);
}
