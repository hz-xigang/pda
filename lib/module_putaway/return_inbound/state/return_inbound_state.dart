import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockInApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class ReturnInboundState extends BasePutawayState {
  ReturnInboundState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        );

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.returnInbound;

  @override
  int get tagFlag => 7;

  @override
  String buildSpec(ProdTag firstTag) {
    return '${firstTag.spec ?? '--'} | ${firstTag.inventoryCode ?? '--'}';
  }

  Future<void> confirmReturnInbound(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认退货入库吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    final locId = selectedLocation?.id;

    FeedbackUtil.showLoading('退货入库中...');
    await StockInApi.add({
      'locId': locId,
      'tagNos': tagNos,
    });
    FeedbackUtil.showSuccess('退货入库成功');
    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }
}

class ReturnInboundScope extends InheritedNotifier<ReturnInboundState> {
  const ReturnInboundScope({
    super.key,
    required ReturnInboundState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ReturnInboundState watch(BuildContext context) {
    final ReturnInboundScope? scope =
        context.dependOnInheritedWidgetOfExactType<ReturnInboundScope>();
    assert(scope != null, 'ReturnInboundScope not found in context.');
    return scope!.notifier!;
  }

  static ReturnInboundState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<ReturnInboundScope>();
    final ReturnInboundScope? scope = element?.widget as ReturnInboundScope?;
    assert(scope != null, 'ReturnInboundScope not found in context.');
    return scope!.notifier!;
  }
}
