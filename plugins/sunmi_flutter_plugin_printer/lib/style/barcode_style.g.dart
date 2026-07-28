// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeStyle _$BarcodeStyleFromJson(Map<String, dynamic> json) => BarcodeStyle(
      BarcodeFormat.fromJson(json['barcodeFormat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BarcodeStyleToJson(BarcodeStyle instance) =>
    <String, dynamic>{
      'barcodeFormat': instance.barcodeFormat.toJson(),
    };
