import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/PalletApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class PalletState extends BaseProdTagScanState {
  PalletState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        ) {
    if (this.useCache) {
      loadCachedTags();
    }
  }

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.pallet;

  @override
  int get palletFlag => 1;

  List<PalletProductItem> get products {
    final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
    for (final ProdTag tag in scannedTags) {
      final String poId = tag.prodOrderId ?? 'unknown_po';
      groups.putIfAbsent(poId, () => <ProdTag>[]).add(tag);
    }

    return groups.entries.map((entry) {
      final List<ProdTag> tags = entry.value;
      final ProdTag firstTag = tags.first;
      final double totalQty = tags.fold<double>(
        0.0,
        (sum, tag) => sum + (tag.qty ?? 0.0),
      );

      return PalletProductItem(
        prodOrderId: entry.key,
        name: firstTag.productCategory ?? '未知分类',
        prodNo: firstTag.prodNo ?? '未知单号',
        spec: '${firstTag.spec ?? '--'} | ${firstTag.customerCode ?? '--'}',
        count: totalQty.toInt(),
        tags: tags,
      );
    }).toList();
  }

  int get totalCount => scannedTags
      .fold<double>(0.0, (sum, tag) => sum + (tag.qty ?? 0.0))
      .toInt();

  int get currentStep => scannedTags.isEmpty ? 1 : 2;

  Future<void> confirmPallet(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确定要确认打托吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    FeedbackUtil.showLoading('上传中...');
    await PalletApi.add(tagNos);
    FeedbackUtil.showSuccess('上传成功');

    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }

  void removeTags(List<ProdTag> tagsToRemove) async {
    final Set<String> removedKeys = tagsToRemove.map(_tagIdentity).toSet();
    scannedTags = scannedTags
        .where((tag) => !removedKeys.contains(_tagIdentity(tag)))
        .toList();
    await saveTags();
    notifyListeners();
  }

  void removeProductGroup(String prodNo) async {
    scannedTags = scannedTags.where((tag) => tag.prodNo != prodNo).toList();
    await saveTags();
    notifyListeners();
  }

  String _tagIdentity(ProdTag tag) {
    return <String>[
      tag.id ?? '',
      tag.tagNo ?? '',
      tag.prodOrderId ?? '',
      tag.prodNo ?? '',
      tag.qty?.toString() ?? '',
      tag.createTime?.toIso8601String() ?? '',
    ].join('|');
  }
}

class PalletScope extends InheritedNotifier<PalletState> {
  const PalletScope({
    super.key,
    required PalletState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static PalletState watch(BuildContext context) {
    final PalletScope? scope =
        context.dependOnInheritedWidgetOfExactType<PalletScope>();
    assert(scope != null, 'PalletScope not found in context.');
    return scope!.notifier!;
  }

  static PalletState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<PalletScope>();
    final PalletScope? scope = element?.widget as PalletScope?;
    assert(scope != null, 'PalletScope not found in context.');
    return scope!.notifier!;
  }
}
