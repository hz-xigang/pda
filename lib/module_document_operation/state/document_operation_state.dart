import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/StockOrderApi.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';
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

  DocumentOperationState({
    List<ProdTag>? initialScannedTags,
    bool useCache = true,
  }) : super(
          initialScannedTags: initialScannedTags,
          useCache: useCache,
        ) {
    _syncSelectedDocument(_documentsByType(_selectedOrderType.key));
    if (this.useCache) {
      loadCachedTags();
    }
    initOrderList();
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

  DocumentOperationTypeOption get selectedOrderType => _selectedOrderType;
  DocumentOperationDocumentOption? get selectedDocument => _selectedDocument;
  List<DocumentOperationDocumentOption> get documentOptions =>
      _documentsByType(_selectedOrderType.key);
  bool get canSwitchSelectors => scannedTags.isEmpty;

  List<PalletProductItem> get products {
    final Map<String, List<ProdTag>> groups = <String, List<ProdTag>>{};
    for (final ProdTag tag in scannedTags) {
      final String poId = tag.prodOrderId ?? 'unknown_po';
      groups.putIfAbsent(poId, () => <ProdTag>[]).add(tag);
    }

    return groups.entries.map((entry) {
      final List<ProdTag> tags = entry.value;
      final ProdTag firstTag = tags.first;
      final int totalQty = tags.fold<int>(
        0,
        (sum, tag) => sum + (tag.qty ?? 0).toInt(),
      );

      return PalletProductItem(
        prodOrderId: entry.key,
        name: firstTag.productCategory ?? '--',
        prodNo: firstTag.prodNo ?? '--',
        spec: '${firstTag.spec ?? '--'} | ${firstTag.inventoryCode ?? '--'}',
        count: totalQty,
        tags: tags,
      );
    }).toList(growable: false);
  }

  int get totalCount => products.fold<int>(
        0,
        (sum, item) => sum + item.count,
      );

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

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认执行${_selectedOrderType.label} ${_selectedDocument!.no}吗？',
    );
    if (!confirm) {
      return;
    }
    FeedbackUtil.showLoading('提交中...');
    var req = {
      "no" : _selectedDocument!.no,
      "tagNos" : scannedTags.map((tag) => tag.tagNo).toList()
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
        return _prepList.isEmpty ? _defaultPrepDocuments : _prepList;
      case 'delivery_out':
        return _shipList.isEmpty ? _defaultShipDocuments : _shipList;
      case 'transfer':
        return _transferList.isEmpty ? _defaultDocuments : _transferList;
      default:
        return _defaultDocuments;
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

  static const List<DocumentOperationDocumentOption> _defaultDocuments =
      <DocumentOperationDocumentOption>[
        DocumentOperationDocumentOption(
          id: '5',
          no: 'DB-001',
        ),
        DocumentOperationDocumentOption(
          id: '6',
          no: 'DB-002',
        ),
      ];

  static const List<DocumentOperationDocumentOption> _defaultPrepDocuments =
      <DocumentOperationDocumentOption>[
        DocumentOperationDocumentOption(
          id: '1',
          no: 'BH-001',
        ),
        DocumentOperationDocumentOption(
          id: '2',
          no: 'BH-002',
        ),
      ];

  static const List<DocumentOperationDocumentOption> _defaultShipDocuments =
      <DocumentOperationDocumentOption>[
        DocumentOperationDocumentOption(
          id: '3',
          no: 'FH-001',
        ),
        DocumentOperationDocumentOption(
          id: '4',
          no: 'FH-002',
        ),
      ];
}

class DocumentOperationScope
    extends InheritedNotifier<DocumentOperationState> {
  const DocumentOperationScope({
    super.key,
    required DocumentOperationState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static DocumentOperationState watch(BuildContext context) {
    final DocumentOperationScope? scope =
        context.dependOnInheritedWidgetOfExactType<DocumentOperationScope>();
    assert(scope != null, 'DocumentOperationScope not found in context.');
    return scope!.notifier!;
  }

  static DocumentOperationState read(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<DocumentOperationScope>();
    final DocumentOperationScope? scope =
        element?.widget as DocumentOperationScope?;
    assert(scope != null, 'DocumentOperationScope not found in context.');
    return scope!.notifier!;
  }
}
