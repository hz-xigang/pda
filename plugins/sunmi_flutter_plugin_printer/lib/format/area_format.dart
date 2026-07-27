import 'package:json_annotation/json_annotation.dart';

import 'format.dart' show Format;

part 'area_format.g.dart'; // 生成的代码文件

@JsonSerializable(explicitToJson: true)
class AreaFormat extends Format {
  /// 区域样式
  int style;

  /// 结束坐标位置X
  int endX;

  /// 结束坐标位置Y
  int endY;

  /// 线条粗细大小
  int thickness;

  // 默认构造函数
  AreaFormat({
    this.style = 0,
    this.endX = 0,
    this.endY = 0,
    this.thickness = 0,
  }): super();

  // 从 JSON 创建 AreaFormat 实例
  factory AreaFormat.fromJson(Map<String, dynamic> json) => _$AreaFormatFromJson(json);

  // 转换为 JSON
  Map<String, dynamic> toJson() => _$AreaFormatToJson(this);
}
