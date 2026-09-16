import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/StockInApi.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class ReturnInboundState extends BasePutawayState {
  ReturnInboundState();

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
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.returnInbound;

  @override
  int get tagFlag => 7;

  Future<void> confirmReturnInbound(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    if (selectedLocation == null) {
      FeedbackUtil.showInfo('请先扫描目标库位');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      content: '确认退货入库到 [$selectedLocationLabel] 吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();
    final locId = selectedLocation?.id;

    FeedbackUtil.showLoading('退货入库中...');
    try {
      var res = await StockInApi.add(
        {
          'locId': locId,
          'tagNos': tagNos,
        },
        type: 1,
        showDefaultAlert: false,
      );

      FeedbackUtil.dismiss();
      if (res != null && res.length == 0) {
        FeedbackUtil.showSuccess('退货入库成功');
      } else if (res != null) {
        DialogUtil.showAlert(content: res.toString());
      } else {
        FeedbackUtil.showSuccess('退货入库成功');
      }

      scannedTags = <ProdTag>[];
      await clearCachedTags();
      notifyListeners();
    } on ApiException catch (e) {
      FeedbackUtil.dismiss();
      if (e.code == 10008) {
        final List<dynamic> failList = e.data is List ? (e.data as List) : [];
        final StringBuffer sb = StringBuffer();
        sb.writeln(e.message.isNotEmpty ? e.message : '部分条码入库失败，请核对后重试');
        final Set<String> failTagNos = <String>{};
        for (final item in failList) {
          if (item is Map) {
            final tagNo = item['tagNo']?.toString() ?? '';
            final reason = item['reason']?.toString() ?? '';
            if (tagNo.isNotEmpty) {
              failTagNos.add(tagNo);
            }
            sb.writeln('$tagNo：$reason');
          }
        }

        DialogUtil.showAlert(content: sb.toString().trim());

        // 保留失败的条码
        scannedTags.removeWhere((tag) => !failTagNos.contains(tag.tagNo));
        await saveTags();
        notifyListeners();
      } else {
        DialogUtil.showAlert(content: e.message);
      }
    } catch (e) {
      FeedbackUtil.dismiss();
      DialogUtil.showAlert(content: '未知异常: $e');
    }
  }
}

typedef ReturnInboundScope = NotifierScope<ReturnInboundState>;

