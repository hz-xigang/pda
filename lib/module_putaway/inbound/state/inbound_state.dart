import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockInApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class InboundState extends BasePutawayState {
  InboundState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        );

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.inbound;

  @override
  int get tagFlag => 2;

  @override
  String buildSpec(ProdTag firstTag) {
    return '${firstTag.spec ?? '--'} | ${firstTag.inventoryCode ?? '--'}';
  }

  Future<void> confirmInbound(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认入库吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    final locId = selectedLocation?.id;

    FeedbackUtil.showLoading('入库中...');
    await StockInApi.add({
      'locId': locId,
      'tagNos': tagNos,
    });
    FeedbackUtil.showSuccess('入库成功');
    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
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
