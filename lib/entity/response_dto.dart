import 'dart:convert';

class ResponseDto {
  const ResponseDto({
    this.code,
    this.success = false,
    this.message = '',
    this.data,
  });

  final int? code;
  final bool success;
  final String message;
  final dynamic data;

  ResponseDto copyWith({
    int? code,
    bool? success,
    String? message,
    dynamic data,
  }) {
    return ResponseDto(
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ResponseDto.fromJson(Map<String, dynamic> json) {
    return ResponseDto(
      code: _asInt(json['code']),
      success: _asBool(json['success']) ?? false,
      message: _asString(json['message']) ?? '',
      data: json['data'],
    );
  }

  static ResponseDto fromJsonString(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map) {
      throw const FormatException('JSON string is not an object.');
    }

    return ResponseDto.fromJson(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  static bool? _asBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final String normalized = value.toString().trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
    return null;
  }
}
