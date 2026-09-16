import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockMoveApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class MoveState extends BasePutawayState {
  MoveState();

  bool _isScanningLocation = false;
  bool get isScanningLocation => _isScanningLocation;

  void toggleScanLocationMode([bool? enabled]) {
    _isScanningLocation = enabled ?? !_isScanningLocation;
    notifyListeners();
  }

  /// 统一处理扫码事件：优先判断是否处于扫描目标库位模式，否则作为产品/托盘扫码
  Future<void> onScan(String barcode, BuildContext context) async {
    final cleanCode = barcode.trim();
    if (cleanCode.isEmpty) return;

    if (_isScanningLocation) {
      LocArchive? matched;
      for (final loc in locationOptions) {
        if (loc.locCode?.trim().toUpperCase() == cleanCode.toUpperCase()) {
          matched = loc;
          break;
        }
      }

      if (matched == null) {
        PdaUtil.errorScan('库位 [$cleanCode] 不存在', context: context);
        return;
      }

      updateLocation(matched);
      _isScanningLocation = false;
      FeedbackUtil.showSuccess('目标库位锁定: ${matched.locCode}');
      notifyListeners();
      return;
    }

    await onScanProduct(cleanCode, context);
  }

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.move;

  @override
  int get tagFlag => 3;

  @override
  String buildSpec(ProdTag tag) =>
      '原库位: ${tag.locCode ?? '--'}\n${tag.spec ?? '--'} | ${tag.inventoryCode ?? '--'}';

  Future<void> confirmMove(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    if (selectedLocation == null) {
      FeedbackUtil.showInfo('请先扫描目标库位');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      content: '确认移库到 [$selectedLocationLabel] 吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    final locId = selectedLocation?.id;
    FeedbackUtil.showLoading('移库中...');
    var res = await StockMoveApi.add({
      'locId': locId,
      'tagNos': tagNos,
    });

    if(res != null && res.length == 0){
      FeedbackUtil.showSuccess('移库成功');
    }else{
      DialogUtil.showAlert(content: res);
    }

    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }
}

typedef MoveScope = NotifierScope<MoveState>;

