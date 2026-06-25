import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

abstract class BaseProdTagScanState extends ChangeNotifier {
  BaseProdTagScanState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  })  : useCache = useCache,
        scannedTags = List<ProdTag>.from(
          initialScannedTags ?? const <ProdTag>[],
        );

  final bool useCache;
  List<ProdTag> scannedTags;

  ProgTagCacheKey get cacheKey;

  @protected
  int get palletFlag;

  Future<void> loadCachedTags() async {
    scannedTags = List<ProdTag>.from(
      await ProgTagCacheProvider.getTags(cacheKey),
    );
    notifyListeners();
  }

  Future<void> saveTags() async {
    if (!useCache) {
      return;
    }
    await ProgTagCacheProvider.saveTags(cacheKey, scannedTags);
  }

  Future<void> clearCachedTags() async {
    if (!useCache) {
      return;
    }
    await ProgTagCacheProvider.clearTags(cacheKey);
  }

  Future<void> onScanProduct(String barcode, BuildContext context) async {
    final String cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) {
      return;
    }

    try {
      FeedbackUtil.showLoading('正在获取标签信息...');
      final ProdTag tag = await ProdTagApi.findByTagNo(
        cleanBarcode,
        palletFlag,
        (e) => PdaUtil.errorScan(context, e.message),
      );

      if (tag.id != null && scannedTags.any((t) => t.id == tag.id)) {
        PdaUtil.errorScan(context, '该标签已扫描');
        EasyLoading.dismiss();
        return;
      }

      scannedTags = <ProdTag>[...scannedTags, tag];
      await saveTags();
      FeedbackUtil.showSuccess('添加成功');
      notifyListeners();
    } catch (e) {
      final String message = e is ApiException ? e.message : e.toString();
      FeedbackUtil.showError(message);
    }
  }
}
