import 'package:json_annotation/json_annotation.dart';
import 'format.dart'; // 假设 Format 类在 format.dart 文件中

part 'qr_format.g.dart';

/// QR 格式
@JsonSerializable(explicitToJson: true)
class QrFormat extends Format {
  /// 点大小
  int dotSize;

  /// 纠错等级
  int errorLevel;

  /// 条码类型
  int symbology;

  QrFormat({
    this.dotSize = 0,
    this.errorLevel = 0,
    this.symbology = 0,
  }) : super();

  /// 从 JSON 创建 QrFormat 实例
  factory QrFormat.fromJson(Map<String, dynamic> json) => _$QrFormatFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$QrFormatToJson(this);
}
