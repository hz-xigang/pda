// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrFormat _$QrFormatFromJson(Map<String, dynamic> json) => QrFormat(
      dotSize: (json['dotSize'] as num?)?.toInt() ?? 0,
      errorLevel: (json['errorLevel'] as num?)?.toInt() ?? 0,
      symbology: (json['symbology'] as num?)?.toInt() ?? 0,
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$QrFormatToJson(QrFormat instance) => <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'dotSize': instance.dotSize,
      'errorLevel': instance.errorLevel,
      'symbology': instance.symbology,
    };
