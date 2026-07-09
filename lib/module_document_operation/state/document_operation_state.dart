import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/pallet_product_item.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

class DocumentOperationTypeOption {
  const DocumentOperationTypeOption({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}

class DocumentOperationDocumentOption {
  const DocumentOperationDocumentOption({
    required this.key,
    required this.label,
    required this.summaryName,
    required this.summarySpec,
    required this.summaryQty,
    required this.products,
  });

  final String key;
  final String label;
  final String summaryName;
  final String summarySpec;
  final int summaryQty;
  final List<PalletProductItem> products;
}

class DocumentOperationState extends ChangeNotifier {
  static const List<DocumentOperationTypeOption> orderTypes =
      <DocumentOperationTypeOption>[
    DocumentOperationTypeOption(
      key: 'transfer_out',
      label: '调拨单（出库）',
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

  DocumentOperationState() {
    final options = _documentsByType(_selectedOrderType.key);
    _selectedDocument = options.isEmpty ? null : options.first;
  }

  DocumentOperationTypeOption get selectedOrderType => _selectedOrderType;
  DocumentOperationDocumentOption? get selectedDocument => _selectedDocument;
  List<DocumentOperationDocumentOption> get documentOptions =>
      _documentsByType(_selectedOrderType.key);
  List<PalletProductItem> get products => _selectedDocument?.products ?? const [];

  int get totalCount => products.fold<int>(
        0,
        (sum, item) => sum + item.count,
      );

  void updateOrderType(DocumentOperationTypeOption? value) {
    if (value == null) {
      return;
    }

    _selectedOrderType = value;
    final options = _documentsByType(value.key);
    _selectedDocument = options.isEmpty ? null : options.first;
    notifyListeners();
  }

  void updateDocument(DocumentOperationDocumentOption? value) {
    if (value == null || value.key == _selectedDocument?.key) {
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

    if (products.isEmpty) {
      FeedbackUtil.showInfo('暂无可操作数据');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      context,
      content: '确认执行${_selectedOrderType.label} ${_selectedDocument!.label}吗？',
    );
    if (!confirm) {
      return;
    }

    FeedbackUtil.showLoading('提交中...');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    FeedbackUtil.showSuccess('操作成功');
  }

  static List<DocumentOperationDocumentOption> _documentsByType(String key) {
    switch (key) {
      case 'stock_prepare':
        return const <DocumentOperationDocumentOption>[
          DocumentOperationDocumentOption(
            key: 'BH-001',
            label: 'BH-001',
            summaryName: '铝合金外壳',
            summarySpec: 'AL-CASE-08',
            summaryQty: 18,
            products: <PalletProductItem>[
              PalletProductItem(
                prodOrderId: 'PO-20260429003',
                name: '铝合金外壳',
                prodNo: 'SC20260429003',
                spec: 'AL-CASE-08 | INV-20240102',
                count: 18,
                tags: <ProdTag>[],
              ),
            ],
          ),
          DocumentOperationDocumentOption(
            key: 'BH-002',
            label: 'BH-002',
            summaryName: '密封圈',
            summarySpec: 'OR-35x3.5-NBR',
            summaryQty: 12,
            products: <PalletProductItem>[
              PalletProductItem(
                prodOrderId: 'PO-20260429005',
                name: '密封圈',
                prodNo: 'SC20260429005',
                spec: 'OR-35x3.5-NBR | INV-20240033',
                count: 12,
                tags: <ProdTag>[],
              ),
            ],
          ),
        ];
      case 'delivery_out':
        return const <DocumentOperationDocumentOption>[
          DocumentOperationDocumentOption(
            key: 'FH-001',
            label: 'FH-001',
            summaryName: '不锈钢垫片',
            summarySpec: 'SS-WASHER-20',
            summaryQty: 42,
            products: <PalletProductItem>[
              PalletProductItem(
                prodOrderId: 'PO-20260429007',
                name: '不锈钢垫片',
                prodNo: 'SC20260429007',
                spec: 'SS-WASHER-20 | INV-20240128',
                count: 42,
                tags: <ProdTag>[],
              ),
            ],
          ),
          DocumentOperationDocumentOption(
            key: 'FH-002',
            label: 'FH-002',
            summaryName: '精密齿轮',
            summarySpec: 'GEAR-48T',
            summaryQty: 16,
            products: <PalletProductItem>[
              PalletProductItem(
                prodOrderId: 'PO-20260429008',
                name: '精密齿轮',
                prodNo: 'SC20260429008',
                spec: 'GEAR-48T | INV-20240156',
                count: 16,
                tags: <ProdTag>[],
              ),
            ],
          ),
        ];
      case 'transfer_out':
      default:
        return _defaultDocuments;
    }
  }

  static const List<DocumentOperationDocumentOption> _defaultDocuments =
      <DocumentOperationDocumentOption>[
        DocumentOperationDocumentOption(
          key: 'DB-001',
          label: 'DB-001',
          summaryName: '精密轴承组件',
          summarySpec: 'BRG-6205-2RS',
          summaryQty: 30,
          products: <PalletProductItem>[
            PalletProductItem(
              prodOrderId: 'PO-20260429001',
              name: '精密轴承组件',
              prodNo: 'SC20260429001',
              spec: 'BRG-6205-2RS | INV-20240056',
              count: 30,
              tags: <ProdTag>[],
            ),
          ],
        ),
        DocumentOperationDocumentOption(
          key: 'DB-002',
          label: 'DB-002',
          summaryName: '减速电机',
          summarySpec: 'GM-12V-100RPM',
          summaryQty: 25,
          products: <PalletProductItem>[
            PalletProductItem(
              prodOrderId: 'PO-20260429004',
              name: '减速电机',
              prodNo: 'SC20260429004',
              spec: 'GM-12V-100RPM | INV-20240011',
              count: 25,
              tags: <ProdTag>[],
            ),
          ],
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
