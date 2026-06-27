import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';

abstract class BasePutawayState extends BaseProdTagScanState {
  BasePutawayState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        ) {
    initLocList();
    if (this.useCache) {
      loadCachedTags();
    }
  }

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;

  List<LocArchive> get locationOptions => _locationOptions;
  LocArchive? get selectedLocation => _selectedLocation;
  String get selectedLocationLabel => _selectedLocation?.locCode ?? '';

  Future<void> initLocList() async {
    final res = await LocApi.list();
    _locationOptions = res;
    if (_selectedLocation == null && _locationOptions.isNotEmpty) {
      _selectedLocation = _locationOptions.first;
    }
    notifyListeners();
  }

  void updateLocation(LocArchive? value) {
    if (value == null || value.id == _selectedLocation?.id) {
      return;
    }
    _selectedLocation = value;
    notifyListeners();
  }

  List<PalletProductItem> get products {
    final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
    for (final ProdTag tag in scannedTags) {
      final String poId = tag.prodOrderId ?? 'unknown_po';
      groups.putIfAbsent(poId, () => <ProdTag>[]).add(tag);
    }

    return groups.entries.map((entry) {
      final List<ProdTag> tags = entry.value;
      final ProdTag firstTag = tags.first;
      final int totalQty = tags.fold<int>(
        0,
        (sum, tag) => sum + (tag.qty ?? 0).toInt(),
      );

      return PalletProductItem(
        prodOrderId: entry.key,
        name: firstTag.productCategory ?? '--',
        prodNo: firstTag.prodNo ?? '--',
        spec: buildSpec(firstTag),
        count: totalQty,
        tags: tags,
      );
    }).toList(growable: false);
  }

  int get totalCount => scannedTags.fold<int>(
        0,
        (sum, tag) => sum + (tag.qty ?? 0).toInt(),
      );

  int get currentStep => 1;

  String buildSpec(ProdTag firstTag);
}
