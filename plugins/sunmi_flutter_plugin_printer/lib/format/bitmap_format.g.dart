// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bitmap_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BitmapFormat _$BitmapFormatFromJson(Map<String, dynamic> json) => BitmapFormat(
      style: (json['style'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toInt() ?? 0,
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$BitmapFormatToJson(BitmapFormat instance) =>
    <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'style': instance.style,
      'value': instance.value,
    };
