import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class InboundState extends ChangeNotifier {
  InboundState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  })  : _useCache = useCache,
        _scannedTags = List<ProdTag>.from(
          initialScannedTags ?? const <ProdTag>[],
        ) {
    initLocList();
    if (_useCache) {
      _loadCachedTags();
    }
  }

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;
  final bool _useCache;
  List<ProdTag> _scannedTags;

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

  Future<void> _loadCachedTags() async {
    _scannedTags = List<ProdTag>.from(
      await ProgTagCacheProvider.getTags(ProgTagCacheKey.inbound),
    );
    notifyListeners();
  }

  Future<void> onScanProduct(String barcode, BuildContext content) async {
    final String cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) {
      return;
    }

    try {
      FeedbackUtil.showLoading('正在获取标签信息...');
      final ProdTag tag = await ProdTagApi.findByTagNo(cleanBarcode, 1, (e) {
        PdaUtil.errorScan(content, e.message);
      });

      if (tag.id != null && _scannedTags.any((t) => t.id == tag.id)) {
        PdaUtil.errorScan(content, '该标签已扫描');
        EasyLoading.dismiss();
        return;
      }

      _scannedTags = <ProdTag>[..._scannedTags, tag];
      await _saveTags();
      FeedbackUtil.showSuccess('添加成功');
      notifyListeners();
    } catch (e) {
      final String message = e is ApiException ? e.message : e.toString();
      FeedbackUtil.showError(message);
    }
  }

  Future<void> _saveTags() async {
    if (!_useCache) {
      return;
    }
    await ProgTagCacheProvider.saveTags(
      ProgTagCacheKey.inbound,
      _scannedTags,
    );
  }

  List<PalletProductItem> get products {
    final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
    for (final ProdTag tag in _scannedTags) {
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
        spec: _mockSpec(firstTag.prodOrderId),
        count: totalQty,
        tags: tags,
      );
    }).toList(growable: false);
  }

  int get totalCount => _scannedTags.fold<int>(
        0,
        (sum, tag) => sum + (tag.qty ?? 0).toInt(),
      );

  int get currentStep => 1;

  void updateLocation(LocArchive? value) {
    if (value == null || value.id == _selectedLocation?.id) {
      return;
    }
    _selectedLocation = value;
    notifyListeners();
  }

  Future<void> confirmInbound(BuildContext context) async {
    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认入库吗？',
    );
    if (!confirm) {
      return;
    }

    FeedbackUtil.showLoading('入库中...');
    FeedbackUtil.showSuccess('确认入库成功');
  }

  static String _mockSpec(String? prodOrderId) {
    switch (prodOrderId) {
      case 'PO-1':
        return 'SP-304-10 | INV-20240078';
      case 'PO-2':
        return 'AL-CASE-08 | INV-20240102';
      default:
        return '--';
    }
  }
}

class InboundScope extends InheritedNotifier<InboundState> {
  const InboundScope({
    super.key,
    required InboundState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static InboundState watch(BuildContext context) {
    final InboundScope? scope =
        context.dependOnInheritedWidgetOfExactType<InboundScope>();
    assert(scope != null, 'InboundScope not found in context.');
    return scope!.notifier!;
  }

  static InboundState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<InboundScope>();
    final InboundScope? scope = element?.widget as InboundScope?;
    assert(scope != null, 'InboundScope not found in context.');
    return scope!.notifier!;
  }
}
