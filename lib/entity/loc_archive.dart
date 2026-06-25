import 'dart:convert';

class LocArchive {
  const LocArchive(this.id, this.locCode);

  final String? id;
  final String? locCode;

  static LocArchive fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return LocArchive(
      map['id']?.toString(),
      map['locCode']?.toString(),
    );
  }

  static LocArchive fromMap(Map<String, dynamic> map) {
    return LocArchive(
      map['id']?.toString(),
      map['locCode']?.toString(),
    );
  }

  static List<LocArchive> listFromDynamic(dynamic value) {
    if (value is! List) {
      throw const FormatException('JSON value is not a list.');
    }

    return value
        .map((item) => LocArchive.fromMap(_asJsonMap(item)))
        .toList(growable: false);
  }

  static Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    }
    throw const FormatException('JSON value is not an object.');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LocArchive &&
        other.id == id &&
        other.locCode == locCode;
  }

  @override
  int get hashCode => Object.hash(id, locCode);

  @override
  String toString() {
    return 'LocArchive{id: $id, locCode: $locCode}';
  }
}
