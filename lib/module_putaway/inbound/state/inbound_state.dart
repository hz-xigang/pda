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

class InboundState extends BasePutawayState {
  InboundState();

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.inbound;

  @override
  int get tagFlag => 2;

  /// 是否处于扫描库位模式
  bool _isScanningLocation = false;
  bool get isScanningLocation => _isScanningLocation;

  /// 切换或设置扫描库位模式
  void toggleScanLocationMode([bool? enabled]) {
    _isScanningLocation = enabled ?? !_isScanningLocation;
    notifyListeners();
  }

  /// 统一扫码入口：区分扫库位还是扫产品/托盘
  Future<void> onScan(String barcode, BuildContext context) async {
    final String cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) {
      return;
    }

    if (_isScanningLocation) {
      _handleLocationScan(cleanBarcode, context);
      return;
    }

    // 默认：产品或托盘扫描
    await onScanProduct(cleanBarcode, context);
  }

  /// 处理库位扫描匹配逻辑
  void _handleLocationScan(String barcode, BuildContext context) {
    if (locationOptions.isEmpty) {
      PdaUtil.errorScan('库位列表为空或未加载完成', context: context);
      return;
    }

    // 比较是否存在对应库位（忽略首尾空格及大小写）
    LocArchive? matched;
    for (final loc in locationOptions) {
      if (loc.locCode != null &&
          loc.locCode!.trim().toUpperCase() == barcode.toUpperCase()) {
        matched = loc;
        break;
      }
    }

    if (matched != null) {
      updateLocation(matched);
      // 扫描成功后自动恢复为产品扫码模式
      _isScanningLocation = false;
      FeedbackUtil.showSuccess('已锁定库位: ${matched.locCode}');
      notifyListeners();
    } else {
      PdaUtil.errorScan('库位 [$barcode] 不存在', context: context);
    }
  }

  Future<void> confirmInbound(BuildContext context) async {
    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可确认的条码');
      return;
    }

    final locId = selectedLocation?.id;
    if (locId == null || locId.isEmpty) {
      FeedbackUtil.showInfo('请先扫描或选择目标库位');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      content: '确认入库到 [$selectedLocationLabel] 吗？',
    );
    if (!confirm) {
      return;
    }

    final List<String> tagNos = scannedTags.map((it) => '${it.tagNo}').toList();

    FeedbackUtil.showLoading('入库中...');
    try {
      var res = await StockInApi.add(
        {
          'locId': locId,
          'tagNos': tagNos,
        },
        showDefaultAlert: false,
      );

      FeedbackUtil.dismiss();
      if (res != null && res.length == 0) {
        FeedbackUtil.showSuccess('入库成功');
      } else if (res != null) {
        DialogUtil.showAlert(content: res.toString());
      } else {
        FeedbackUtil.showSuccess('入库成功');
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

typedef InboundScope = NotifierScope<InboundState>;

