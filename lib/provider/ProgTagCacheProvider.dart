import 'package:hive/hive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

enum ProgTagCacheKey {
  pallet,
  inbound,
  move,
  documentOperation,
}

class ProgTagCacheProvider {
  ProgTagCacheProvider._();

  static const String boxName = 'prod_tag_box';
  static const String cacheMapKey = 'prod_tag_cache_map';

  static Future<Box<dynamic>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }
    return Hive.openBox<dynamic>(boxName);
  }

  static Future<void> saveTags(ProgTagCacheKey key, List<ProdTag> tags) async {
    final box = await _getBox();
    final map = _normalizeCacheMap(box.get(cacheMapKey));
    map[key.name] = List<ProdTag>.from(tags);
    await box.put(cacheMapKey, map);
  }

  static Future<List<ProdTag>> getTags(ProgTagCacheKey key) async {
    final box = await _getBox();
    final map = _normalizeCacheMap(box.get(cacheMapKey));
    return List<ProdTag>.from(map[key.name] ?? const <ProdTag>[]);
  }

  static Future<void> clearTags(ProgTagCacheKey key) async {
    final box = await _getBox();
    final map = _normalizeCacheMap(box.get(cacheMapKey));
    map.remove(key.name);

    if (map.isEmpty) {
      await box.delete(cacheMapKey);
      return;
    }

    await box.put(cacheMapKey, map);
  }

  static Future<void> clearAll() async {
    final box = await _getBox();
    await box.delete(cacheMapKey);
  }

  static Map<String, List<ProdTag>> _normalizeCacheMap(dynamic raw) {
    final Map<String, List<ProdTag>> result = <String, List<ProdTag>>{};

    if (raw is! Map) {
      return result;
    }

    raw.forEach((key, value) {
      if (value is List) {
        result[key.toString()] = value.whereType<ProdTag>().toList();
      }
    });

    return result;
  }
}
