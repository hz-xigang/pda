// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextFormat _$TextFormatFromJson(Map<String, dynamic> json) => TextFormat(
      textSize: (json['textSize'] as num?)?.toInt() ?? 0,
      textWidthRatio: (json['textWidthRatio'] as num?)?.toInt() ?? 0,
      textHeightRatio: (json['textHeightRatio'] as num?)?.toInt() ?? 0,
      textSpace: (json['textSpace'] as num?)?.toInt() ?? 0,
      enUnderline: json['enUnderline'] as bool? ?? false,
      enStrikethrough: json['enStrikethrough'] as bool? ?? false,
      enItalics: json['enItalics'] as bool? ?? false,
      enInvert: json['enInvert'] as bool? ?? false,
      enAntiColor: json['enAntiColor'] as bool? ?? false,
      enBold: json['enBold'] as bool? ?? false,
      customFont: json['customFont'] as String? ?? '',
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$TextFormatToJson(TextFormat instance) =>
    <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'textSize': instance.textSize,
      'textWidthRatio': instance.textWidthRatio,
      'textHeightRatio': instance.textHeightRatio,
      'textSpace': instance.textSpace,
      'enUnderline': instance.enUnderline,
      'enStrikethrough': instance.enStrikethrough,
      'enItalics': instance.enItalics,
      'enInvert': instance.enInvert,
      'enAntiColor': instance.enAntiColor,
      'enBold': instance.enBold,
      'customFont': instance.customFont,
    };
