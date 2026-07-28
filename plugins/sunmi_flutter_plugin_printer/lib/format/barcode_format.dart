import 'package:json_annotation/json_annotation.dart';
import 'format.dart';

part 'barcode_format.g.dart';

/// 条码格式
@JsonSerializable(explicitToJson: true)
class BarcodeFormat extends Format {
  /// 条码类型
  int symbology;

  /// 条码宽度
  int dotWidth;

  /// 条码高度
  int barHeight;

  /// 人类可读性的位置
  int readable;

  BarcodeFormat({
    this.symbology = 0,
    this.dotWidth = 0,
    this.barHeight = 0,
    this.readable = 0,
  }) : super();

  /// 从 JSON 创建 BarcodeFormat 实例
  factory BarcodeFormat.fromJson(Map<String, dynamic> json) => _$BarcodeFormatFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$BarcodeFormatToJson(this);
}
