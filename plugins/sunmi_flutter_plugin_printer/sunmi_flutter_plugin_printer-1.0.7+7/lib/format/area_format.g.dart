// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaFormat _$AreaFormatFromJson(Map<String, dynamic> json) => AreaFormat(
      style: (json['style'] as num?)?.toInt() ?? 0,
      endX: (json['endX'] as num?)?.toInt() ?? 0,
      endY: (json['endY'] as num?)?.toInt() ?? 0,
      thickness: (json['thickness'] as num?)?.toInt() ?? 0,
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$AreaFormatToJson(AreaFormat instance) =>
    <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'style': instance.style,
      'endX': instance.endX,
      'endY': instance.endY,
      'thickness': instance.thickness,
    };
