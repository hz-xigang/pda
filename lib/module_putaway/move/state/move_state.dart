import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockMoveApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class MoveState extends BasePutawayState {
  MoveState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        );

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.move;

  @override
  int get tagFlag => 3;

  @override
  String buildSpec(ProdTag firstTag) {
    return '原库位: ${firstTag.locCode ?? '--'}\n${firstTag.spec ?? '--'} | ${firstTag.inventoryCode ?? '--'}';
  }

  Future<void> confirmMove(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认移库吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    final locId = selectedLocation?.id;
    FeedbackUtil.showLoading('移库中...');
    await StockMoveApi.add({
      'locId': locId,
      'tagNos': tagNos,
    });
    FeedbackUtil.showSuccess('移库成功');
    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }
}

class MoveScope extends InheritedNotifier<MoveState> {
  const MoveScope({
    super.key,
    required MoveState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static MoveState watch(BuildContext context) {
    final MoveScope? scope =
        context.dependOnInheritedWidgetOfExactType<MoveScope>();
    assert(scope != null, 'MoveScope not found in context.');
    return scope!.notifier!;
  }

  static MoveState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<MoveScope>();
    final MoveScope? scope = element?.widget as MoveScope?;
    assert(scope != null, 'MoveScope not found in context.');
    return scope!.notifier!;
  }
}
