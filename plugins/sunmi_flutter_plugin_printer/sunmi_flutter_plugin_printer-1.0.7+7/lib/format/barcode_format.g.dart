// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeFormat _$BarcodeFormatFromJson(Map<String, dynamic> json) =>
    BarcodeFormat(
      symbology: (json['symbology'] as num?)?.toInt() ?? 0,
      dotWidth: (json['dotWidth'] as num?)?.toInt() ?? 0,
      barHeight: (json['barHeight'] as num?)?.toInt() ?? 0,
      readable: (json['readable'] as num?)?.toInt() ?? 0,
    )
      ..xOffset = (json['xOffset'] as num).toInt()
      ..yOffset = (json['yOffset'] as num).toInt()
      ..width = (json['width'] as num).toInt()
      ..height = (json['height'] as num).toInt()
      ..align = (json['align'] as num).toInt()
      ..rotate = (json['rotate'] as num).toInt()
      ..renderColor = (json['renderColor'] as num).toInt();

Map<String, dynamic> _$BarcodeFormatToJson(BarcodeFormat instance) =>
    <String, dynamic>{
      'xOffset': instance.xOffset,
      'yOffset': instance.yOffset,
      'width': instance.width,
      'height': instance.height,
      'align': instance.align,
      'rotate': instance.rotate,
      'renderColor': instance.renderColor,
      'symbology': instance.symbology,
      'dotWidth': instance.dotWidth,
      'barHeight': instance.barHeight,
      'readable': instance.readable,
    };
