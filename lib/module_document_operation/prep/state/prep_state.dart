import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/DocumentOperationDocumentOption.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/http/StockOrderApi.dart';
import 'package:hz_xg_pda/module_document_operation/base/base_document_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

/// 备货单（移库）：独占目标仓位逻辑
class PrepState extends BaseDocumentState {
  PrepState() : super() {
    initLocList();
  }

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;
  bool _isScanningLocation = false;

  bool get isScanningLocation => _isScanningLocation;
  List<LocArchive> get locationOptions => _locationOptions;
  LocArchive? get selectedLocation => _selectedLocation;

  void toggleScanLocationMode([bool? enabled]) {
    _isScanningLocation = enabled ?? !_isScanningLocation;
    notifyListeners();
  }

  void updateLocation(LocArchive? value) {
    if (value == null ||
        !canSwitchSelectors ||
        value.id == _selectedLocation?.id) {
      return;
    }
    _selectedLocation = value;
    notifyListeners();
  }

  Future<void> initLocList() async {
    final res = await LocApi.list();
    _locationOptions = res;
    notifyListeners();
  }

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.prep;

  @override
  int get tagFlag => 4;

  @override
  String get orderLabel => '备货单（移库）';

  @override
  String get documentLabel => '选择备货单号';

  @override
  String get apiCheckType => 'Prep';

  @override
  bool get requiresLocation => true;

  @override
  bool get locationReady => _selectedLocation != null;

  @override
  Map<String, dynamic> buildLocationParams() {
    final locCode = _selectedLocation?.locCode;
    if (locCode == null) {
      return <String, dynamic>{};
    }
    return <String, dynamic>{'locCode': locCode};
  }

  @override
  Future<List<DocumentOperationDocumentOption>> loadDocuments() {
    return StockOrderApi.prepList();
  }

  @override
  Future<void> submitOrder(Map<String, dynamic> req) {
    return StockOrderApi.addPrep(req);
  }

  /// 统一处理扫码事件：优先判断是否处于扫描目标仓位模式，否则作为产品/托盘扫码
  @override
  Future<void> onScan(String barcode, BuildContext context) async {
    final cleanCode = barcode.trim();
    if (cleanCode.isEmpty) return;

    if (_isScanningLocation) {
      LocArchive? matched;
      for (final loc in _locationOptions) {
        if (loc.locCode?.trim().toUpperCase() == cleanCode.toUpperCase()) {
          matched = loc;
          break;
        }
      }

      if (matched == null) {
        PdaUtil.errorScan('仓位 [$cleanCode] 不存在', context: context);
        return;
      }

      _selectedLocation = matched;
      _isScanningLocation = false;
      FeedbackUtil.showSuccess('目标仓位锁定: ${matched.locCode}');
      notifyListeners();
      return;
    }

    await onScanProduct(cleanCode, context);
  }
}

typedef PrepScope = NotifierScope<PrepState>;
