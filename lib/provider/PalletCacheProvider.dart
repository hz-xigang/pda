import 'package:hive/hive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

class PalletCacheProvider {
  PalletCacheProvider._();

  static const String boxName = 'pallet_box';
  static const String scannedTagsKey = 'scanned_tags';

  static Future<Box<dynamic>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }
    return Hive.openBox<dynamic>(boxName);
  }

  static Future<void> saveScannedTags(List<ProdTag> tags) async {
    final box = await _getBox();
    await box.put(scannedTagsKey, tags);
  }

  static Future<List<ProdTag>> getScannedTags() async {
    final box = await _getBox();
    final dynamic raw = box.get(scannedTagsKey);

    if (raw is List) {
      return raw.whereType<ProdTag>().toList();
    }
    return [];
  }

  static Future<void> clearScannedTags() async {
    final box = await _getBox();
    await box.delete(scannedTagsKey);
  }
}
