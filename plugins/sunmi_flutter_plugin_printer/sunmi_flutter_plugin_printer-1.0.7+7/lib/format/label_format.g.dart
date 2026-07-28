// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelFormat _$LabelFormatFromJson(Map<String, dynamic> json) => LabelFormat(
      enableReverse: (json['enableReverse'] as num?)?.toInt() ?? 0,
      enableMirror: (json['enableMirror'] as num?)?.toInt() ?? 0,
      enableBack: (json['enableBack'] as num?)?.toInt() ?? 0,
      enableTear: (json['enableTear'] as num?)?.toInt() ?? 0,
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$LabelFormatToJson(LabelFormat instance) =>
    <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'enableReverse': instance.enableReverse,
      'enableMirror': instance.enableMirror,
      'enableBack': instance.enableBack,
      'enableTear': instance.enableTear,
    };
