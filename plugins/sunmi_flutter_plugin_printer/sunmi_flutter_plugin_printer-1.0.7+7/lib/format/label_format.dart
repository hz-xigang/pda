import 'package:json_annotation/json_annotation.dart';

import 'format.dart' show Format;

part 'label_format.g.dart'; // 生成的文件

@JsonSerializable(explicitToJson: true)
class LabelFormat extends Format {
  /// 标签反转 0 skip, 1 true, 2 false
  int enableReverse;

  /// 标签镜像
  int enableMirror;

  /// 标签回退
  int enableBack;

  /// 标签进纸
  int enableTear;

  LabelFormat({
    this.enableReverse = 0,
    this.enableMirror = 0,
    this.enableBack = 0,
    this.enableTear = 0,
  }) : super();

  /// 从 JSON 构造函数
  factory LabelFormat.fromJson(Map<String, dynamic> json) => _$LabelFormatFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$LabelFormatToJson(this);
}
