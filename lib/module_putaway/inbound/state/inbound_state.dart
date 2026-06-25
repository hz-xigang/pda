import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class InboundState extends ChangeNotifier {
  InboundState() {
    initLocList();
  }

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;

  final List<ProdTag> _scannedTags = <ProdTag>[
    const ProdTag(
      id: '1',
      tagNo: 'TAG-001',
      prodOrderId: 'PO-1',
      productCategory: '不锈钢垫片',
      prodNo: 'SC20260429002',
      qty: 60,
    ),
    const ProdTag(
      id: '2',
      tagNo: 'TAG-002',
      prodOrderId: 'PO-2',
      productCategory: '铝合金外壳',
      prodNo: 'SC20260429003',
      qty: 30,
    ),
  ];

  List<LocArchive> get locationOptions => _locationOptions;
  LocArchive? get selectedLocation => _selectedLocation;
  String get selectedLocationLabel => _selectedLocation?.locCode ?? '';

  Future<void> initLocList() async {
    final res = await LocApi.list();
    print(res);
    _locationOptions = res;
    if (_selectedLocation == null && _locationOptions.isNotEmpty) {
      _selectedLocation = _locationOptions.first;
    }
    notifyListeners();
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

  void onScanProduct(String barcode, BuildContext context) {
    if (barcode.trim().isEmpty) {
      return;
    }
    FeedbackUtil.showInfo('已扫描: $barcode');
  }

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
