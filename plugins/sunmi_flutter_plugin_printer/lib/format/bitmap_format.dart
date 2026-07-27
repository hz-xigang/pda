import '../../format/format.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bitmap_format.g.dart';
@JsonSerializable(explicitToJson: true)
class BitmapFormat extends Format {
  /// 图片转换风格
  int style;

  /// 图片风格调节
  int value;

  BitmapFormat({
    this.style = 0,
    this.value = 0
  }): super();

  factory BitmapFormat.fromJson(Map<String, dynamic> json) => _$BitmapFormatFromJson(json);

  Map<String, dynamic> toJson() => _$BitmapFormatToJson(this);

}