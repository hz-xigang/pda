import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockInApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class InboundState extends BasePutawayState {
  InboundState();

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.inbound;

  @override
  int get tagFlag => 2;

  Future<void> confirmInbound(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
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

typedef InboundScope = NotifierScope<InboundState>;
