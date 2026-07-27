// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Format _$FormatFromJson(Map<String, dynamic> json) => Format(
      xOffset: (json['xOffset'] as num?)?.toInt() ?? 0,
      yOffset: (json['yOffset'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      align: (json['align'] as num?)?.toInt() ?? 0,
      rotate: (json['rotate'] as num?)?.toInt() ?? 0,
      renderColor: (json['renderColor'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FormatToJson(Format instance) => <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
    };
