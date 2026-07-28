import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/PalletApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';
import 'package:hz_xg_pda/util/sunmi_printer_util.dart';

class PalletState extends BaseProdTagScanState {
  PalletState() {
    loadCachedTags();
  }

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.pallet;

  @override
  int get tagFlag => 1;

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
    var res = await PalletApi.add(tagNos);
    print("res@@  $res");

    // res 是需要打印的二维码内容
    FeedbackUtil.dismiss();

    // 打印托盘二维码
    if (res != null && res.toString().isNotEmpty) {
      try {
        // 确保打印机已初始化
        if (!SunmiPrinterUtil.isReady) {
          FeedbackUtil.showLoading('初始化打印机...');
          final initialized = await SunmiPrinterUtil.init();
          FeedbackUtil.dismiss();

          if (!initialized) {
            FeedbackUtil.showError('打印机初始化失败');
            return;
          }
        }

        // 打印二维码
        FeedbackUtil.showLoading('打印中...');
        await SunmiPrinterUtil.printPalletQrCode(
          res.toString(),
          title: "托盘二维码",
        );
        FeedbackUtil.dismiss();
        FeedbackUtil.showSuccess('上传并打印成功');
      } catch (e) {
        FeedbackUtil.dismiss();
        print("打印失败: $e");
        FeedbackUtil.showError('打印失败: $e');
        return;
      }
    } else {
      FeedbackUtil.showSuccess('上传成功');
    }

    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }
}

typedef PalletScope = NotifierScope<PalletState>;
