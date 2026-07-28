// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrStyle _$QrStyleFromJson(Map<String, dynamic> json) => QrStyle(
      QrFormat.fromJson(json['qrFormat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QrStyleToJson(QrStyle instance) => <String, dynamic>{
      'qrFormat': instance.qrFormat.toJson(),
    };
