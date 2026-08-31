import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockMoveApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class MoveState extends BasePutawayState {
  MoveState();

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.move;

  @override
  int get tagFlag => 3;

  @override
  @override
  String buildSpec(ProdTag tag) =>
      '原库位: ${tag.locCode ?? '--'}\n${tag.spec ?? '--'} | ${tag.inventoryCode ?? '--'}';

  Future<void> confirmMove(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
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

typedef MoveScope = NotifierScope<MoveState>;
