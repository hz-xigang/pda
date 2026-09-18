import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/http/StockOrderApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

import '../../entity/DocumentOperationDocumentOption.dart';

class DocumentOperationTypeOption {
  const DocumentOperationTypeOption({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}



class DocumentOperationState extends BaseProdTagScanState {
  static const List<DocumentOperationTypeOption> orderTypes =
      <DocumentOperationTypeOption>[
    DocumentOperationTypeOption(
      key: 'transfer',
      label: '调拨单（出/入库）',
    ),
    DocumentOperationTypeOption(
      key: 'stock_prepare',
      label: '备货单（移库）',
    ),
    DocumentOperationTypeOption(
      key: 'delivery_out',
      label: '发货单（出库）',
    ),
  ];

  DocumentOperationTypeOption _selectedOrderType = orderTypes.first;
  DocumentOperationDocumentOption? _selectedDocument;
  var _transferList = <DocumentOperationDocumentOption>[];
  var _prepList = <DocumentOperationDocumentOption>[];
  var _shipList = <DocumentOperationDocumentOption>[];

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;
  bool _isScanningLocation = false;
  bool get isScanningLocation => _isScanningLocation;

  void toggleScanLocationMode([bool? enabled]) {
    _isScanningLocation = enabled ?? !_isScanningLocation;
    notifyListeners();
  }

  /// 统一处理扫码事件：优先判断是否处于扫描目标仓位模式，否则作为产品/托盘扫码
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

  DocumentOperationState() {
    _syncSelectedDocument(_documentsByType(_selectedOrderType.key));
    loadCachedTags();
    initOrderList();
    initLocList();
  }

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.documentOperation;

  @override
  int get tagFlag {
    switch (_selectedOrderType.key) {
      case 'stock_prepare':
        return 4;
      case 'delivery_out':
        return 5;
      case 'transfer':
      default:
        return 6;
    }
  }

  /// 转换当前单据类型为 ProdTagApi 识别的 type 字符串 (Ship, Transfer, Prep)
  String get _apiCheckType {
    switch (_selectedOrderType.key) {
      case 'delivery_out':
        return 'Ship';
      case 'stock_prepare':
        return 'Prep';
      case 'transfer':
      default:
        return 'Transfer';
    }
  }

  @override
  Future<ProdTag> fetchSingleTag(
    String barcode, {
    BuildContext? context,
  }) async {
    if (_selectedDocument == null || _selectedDocument!.no.isEmpty) {
      throw Exception('请先选择单据后再进行扫码');
    }

    return ProdTagApi.checkOrderNo(
      barcode,
      _selectedDocument!.no,
      _apiCheckType,
      (e) => PdaUtil.errorScan(e.message, context: context,needDialog: false),
    );
  }

  DocumentOperationTypeOption get selectedOrderType => _selectedOrderType;
  DocumentOperationDocumentOption? get selectedDocument => _selectedDocument;
  List<DocumentOperationDocumentOption> get documentOptions =>
      _documentsByType(_selectedOrderType.key);
  bool get canSwitchSelectors => scannedTags.isEmpty;
  bool get isPrepOrder => _selectedOrderType.key == 'stock_prepare';

  List<LocArchive> get locationOptions => _locationOptions;
  LocArchive? get selectedLocation => _selectedLocation;

  Future<void> initLocList() async {
    final res = await LocApi.list();
    _locationOptions = res;
    notifyListeners();
  }

  void updateLocation(LocArchive? value) {
    if (value == null || !canSwitchSelectors || value.id == _selectedLocation?.id) {
      return;
    }
    _selectedLocation = value;
    notifyListeners();
  }

  Future<void> updateOrderType(DocumentOperationTypeOption? value) async {
    if (value == null || !canSwitchSelectors) {
      return;
    }

    _selectedOrderType = value;
    _syncSelectedDocument(_documentsByType(value.key));
    notifyListeners();
    await initOrderList();
  }

  void updateDocument(DocumentOperationDocumentOption? value) {
    if (value == null || !canSwitchSelectors || value.id == _selectedDocument?.id) {
      return;
    }

    _selectedDocument = value;
    notifyListeners();
  }

  Future<void> confirmOperation(BuildContext context) async {
    if (_selectedDocument == null) {
      FeedbackUtil.showInfo('请选择单据');
      return;
    }

    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可操作数据');
      return;
    }

    if (isPrepOrder && _selectedLocation == null) {
      FeedbackUtil.showInfo('请先扫描目标仓位');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      content: '确认执行${_selectedOrderType.label} ${_selectedDocument!.no}吗？',
    );
    if (!confirm) {
      return;
    }
    FeedbackUtil.showLoading('提交中...');
    var req = <String, dynamic>{
      "no": _selectedDocument!.no,
      "tagNos": scannedTags.map((tag) => tag.tagNo).toList(),
      if (isPrepOrder && _selectedLocation?.locCode != null)
        "locCode": _selectedLocation!.locCode,
    };

    if(_selectedOrderType.key == 'delivery_out'){
       await StockOrderApi.addShip(req);
       FeedbackUtil.showSuccess('操作成功');
       scannedTags = <ProdTag>[];
       await clearCachedTags();
       notifyListeners();
    }else if(_selectedOrderType.key == 'transfer'){
      await StockOrderApi.addTransfer(req);
      FeedbackUtil.showSuccess('操作成功');
      scannedTags = <ProdTag>[];
      await clearCachedTags();
      notifyListeners();
    }else{
      await StockOrderApi.addPrep(req);
      FeedbackUtil.showSuccess('操作成功');
      scannedTags = <ProdTag>[];
      await clearCachedTags();
      notifyListeners();
    }


  }


  Future<void> initOrderList() async {
    switch (_selectedOrderType.key) {
      case 'stock_prepare':
        _prepList = await StockOrderApi.prepList();
        _syncSelectedDocument(_prepList);
        break;
      case 'delivery_out':
        _shipList = await StockOrderApi.shipList();
        _syncSelectedDocument(_shipList);
        break;
      case 'transfer':
      default:
        _transferList = await StockOrderApi.transferList();
        _syncSelectedDocument(_transferList);
        break;
    }
    notifyListeners();
  }

  List<DocumentOperationDocumentOption> _documentsByType(String key) {
    switch (key) {
      case 'stock_prepare':
        return _prepList;
      case 'delivery_out':
        return _shipList;
      case 'transfer':
        return _transferList;
      default:
        return _transferList;
    }
  }

  void _syncSelectedDocument(List<DocumentOperationDocumentOption> options) {
    if (options.isEmpty) {
      _selectedDocument = null;
      return;
    }

    final currentId = _selectedDocument?.id;
    if (currentId == null) {
      _selectedDocument = options.first;
      return;
    }

    final matched = options.where((item) => item.id == currentId);
    _selectedDocument = matched.isEmpty ? options.first : matched.first;
  }
}

typedef DocumentOperationScope = NotifierScope<DocumentOperationState>;
