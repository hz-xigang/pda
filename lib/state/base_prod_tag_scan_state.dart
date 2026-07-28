import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/http/PalletApi.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

abstract class BaseProdTagScanState extends ChangeNotifier {
  BaseProdTagScanState() : scannedTags = <ProdTag>[];

  List<ProdTag> scannedTags;

  ProgTagCacheKey get cacheKey;

  @protected
  int get tagFlag;

  @protected
  String buildSpec(ProdTag tag) =>
      '${tag.spec ?? '--'} | ${tag.inventoryCode ?? '--'}';

  List<PalletProductItem> get products {
    final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
    for (final ProdTag tag in scannedTags) {
      groups.putIfAbsent(tag.prodOrderId ?? 'unknown_po', () => <ProdTag>[]).add(tag);
    }
    return groups.entries.map((entry) {
      final List<ProdTag> tags = entry.value;
      final ProdTag first = tags.first;
      return PalletProductItem(
        prodOrderId: entry.key,
        name: first.productCategory ?? '--',
        prodNo: first.prodNo ?? '--',
        spec: buildSpec(first),
        count: _sumQty(tags),
        tags: tags,
      );
    }).toList(growable: false);
  }

  int get totalCount => _sumQty(scannedTags);

  int _sumQty(List<ProdTag> tags) =>
      tags.fold<double>(0.0, (sum, tag) => sum + (tag.qty ?? 0.0)).toInt();

  Future<void> loadCachedTags() async {
    scannedTags = List<ProdTag>.from(
      await ProgTagCacheProvider.getTags(cacheKey),
    );
    notifyListeners();
  }

  Future<void> saveTags() async {
    await ProgTagCacheProvider.saveTags(cacheKey, scannedTags);
  }

  Future<void> clearCachedTags() async {
    await ProgTagCacheProvider.clearTags(cacheKey);
  }

  Future<void> onScanProduct(String barcode, BuildContext context) async {
    final String cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) {
      return;
    }

    // 扫描托盘条码（以3开头），批量获取标签
    if (barcode.startsWith("3")) {
      try {
        FeedbackUtil.showLoading('正在获取托盘标签信息...');
        List<ProdTag> tags = await PalletApi.findTagsByPallet(
          cleanBarcode,
          tagFlag,
          (e) => PdaUtil.errorScan(context, e.message),
        );

        if (tags.isEmpty) {
          FeedbackUtil.showInfo('该托盘无可用标签');
          return;
        }

        // 过滤掉已经扫描过的标签
        final List<ProdTag> newTags = tags.where((tag) {
          return tag.id != null && !scannedTags.any((t) => t.id == tag.id);
        }).toList();

        if (newTags.isEmpty) {
          FeedbackUtil.showInfo('该托盘的所有标签均已扫描');
          return;
        }

        // 添加新标签
        scannedTags = <ProdTag>[...scannedTags, ...newTags];
        await saveTags();

        final int skippedCount = tags.length - newTags.length;
        if (skippedCount > 0) {
          FeedbackUtil.showSuccess('添加 ${newTags.length} 个标签，跳过 $skippedCount 个重复标签');
        } else {
          FeedbackUtil.showSuccess('添加 ${newTags.length} 个标签');
        }

        notifyListeners();
      } catch (e) {
        final String message = e is ApiException ? e.message : e.toString();
        FeedbackUtil.showError(message);
      }
      return;
    }

    // 扫描单个产品标签
    try {
      FeedbackUtil.showLoading('正在获取标签信息...');
      final ProdTag tag = await ProdTagApi.findByTagNo(
        cleanBarcode,
        tagFlag,
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

  Future<void> removeTags(List<ProdTag> tagsToRemove) async {
    scannedTags = scannedTags
        .where((tag) => !tagsToRemove.any((r) => identical(tag, r)))
        .toList();
    await saveTags();
    notifyListeners();
  }

  Future<void> removeProductGroup(String prodNo) async {
    scannedTags = scannedTags.where((tag) => tag.prodNo != prodNo).toList();
    await saveTags();
    notifyListeners();
  }
}
