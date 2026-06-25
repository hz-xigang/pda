import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/PalletApi.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/provider/PalletCacheProvider.dart';
import 'package:hz_xg_pda/util/HapticUtil.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';
import 'package:vibration/vibration.dart';

class PalletState extends ChangeNotifier {
  PalletState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  })  : _useCache = useCache,
        _scannedTags = List<ProdTag>.from(
          initialScannedTags ?? const <ProdTag>[],
        ) {
    if (_useCache) {
      _loadCachedTags();
    }
  }

  final bool _useCache;
  List<ProdTag> _scannedTags;

  List<ProdTag> get scannedTags => _scannedTags;

  Future<void> _loadCachedTags() async {
    _scannedTags = List<ProdTag>.from(
      await PalletCacheProvider.getScannedTags(),
    );
    notifyListeners();
  }

  Future<void> _saveTags() async {
    if (!_useCache) {
      return;
    }
    await PalletCacheProvider.saveScannedTags(_scannedTags);
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
      final double totalQty = tags.fold<double>(
        0.0,
        (sum, tag) => sum + (tag.qty ?? 0.0),
      );

      return PalletProductItem(
        prodOrderId: entry.key,
        name: firstTag.productCategory ?? '未知分类',
        prodNo: firstTag.prodNo ?? '未知单号',
        spec: '生产订单ID: ${entry.key}',
        count: totalQty.toInt(),
        tags: tags,
      );
    }).toList();
  }

  int get totalCount => _scannedTags
      .fold<double>(0.0, (sum, tag) => sum + (tag.qty ?? 0.0))
      .toInt();

  int get currentStep => _scannedTags.isEmpty ? 1 : 2;

  Future<void> onScanProduct(String barcode,BuildContext content) async {
    final String cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) {
      return;
    }

    try {
      FeedbackUtil.showLoading('正在获取标签信息...');
      final ProdTag tag = await ProdTagApi.findByTagNo(cleanBarcode,1,(e){

        PdaUtil.errorScan(content, e.message);
      });

      if (tag.id != null && _scannedTags.any((t) => t.id == tag.id)) {
        FeedbackUtil.showInfo('该标签已扫描');
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

  Future<void> confirmPallet(BuildContext context) async {
    if (_scannedTags.isEmpty) {
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

    final List<String> tagNos = _scannedTags.map((it) => '${it.tagNo}').toList();
    FeedbackUtil.showLoading('上传中...');
    await PalletApi.add(tagNos);
    FeedbackUtil.showSuccess('上传成功');

    _scannedTags = <ProdTag>[];
    if (_useCache) {
      await PalletCacheProvider.clearScannedTags();
    }
    notifyListeners();
  }

  void removeTags(List<ProdTag> tagsToRemove) async {
    final Set<String> removedKeys = tagsToRemove.map(_tagIdentity).toSet();
    _scannedTags = _scannedTags
        .where((tag) => !removedKeys.contains(_tagIdentity(tag)))
        .toList();
    await _saveTags();
    notifyListeners();
  }

  void removeProductGroup(String prodNo) async {
    _scannedTags = _scannedTags.where((tag) => tag.prodNo != prodNo).toList();
    await _saveTags();
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
