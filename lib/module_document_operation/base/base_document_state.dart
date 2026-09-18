import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/DocumentOperationDocumentOption.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/ProdTagApi.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';
import 'package:hz_xg_pda/util/feedback_util.dart';

/// 单据操作公共基类：单据选择、下拉同步、扫码校验骨架、提交骨架。
/// 单据类型相关全部抽象化，transfer / prep / ship 三个子类各自写死常量。
abstract class BaseDocumentState extends BaseProdTagScanState {
  BaseDocumentState() {
    _syncSelectedDocument(_documents);
    loadCachedTags();
    initOrderList();
  }

  List<DocumentOperationDocumentOption> _documents =
      <DocumentOperationDocumentOption>[];
  DocumentOperationDocumentOption? _selectedDocument;

  /// 确认框文案中的单据类型名，如 '调拨单（出/入库）'
  String get orderLabel;

  /// 单据下拉区标题，如 '选择调拨单号'
  String get documentLabel;

  /// ProdTagApi 识别的校验类型：Transfer / Prep / Ship
  String get apiCheckType;

  /// 加载本单据类型的单据列表
  Future<List<DocumentOperationDocumentOption>> loadDocuments();

  /// 提交本单据类型的操作请求
  Future<void> submitOrder(Map<String, dynamic> req);

  /// 是否需要目标仓位（仅备货单为 true）
  bool get requiresLocation => false;

  /// 仓位是否就绪（仅备货单覆写）
  bool get locationReady => true;

  /// 附加的位置参数（仅备货单覆写，返回 {'locCode': ...}）
  Map<String, dynamic> buildLocationParams() => <String, dynamic>{};

  List<DocumentOperationDocumentOption> get documentOptions => _documents;
  DocumentOperationDocumentOption? get selectedDocument => _selectedDocument;
  bool get canSwitchSelectors => scannedTags.isEmpty;

  /// 默认扫码入口：直接作为产品/托盘扫码（备货单覆写以支持仓位扫码）
  Future<void> onScan(String barcode, BuildContext context) {
    return onScanProduct(barcode, context);
  }

  @override
  Future<ProdTag> fetchSingleTag(
    String barcode, {
    BuildContext? context,
  }) {
    if (_selectedDocument == null || _selectedDocument!.no.isEmpty) {
      throw Exception('请先选择单据后再进行扫码');
    }

    return ProdTagApi.checkOrderNo(
      barcode,
      _selectedDocument!.no,
      apiCheckType,
      (e) => PdaUtil.errorScan(e.message, context: context, needDialog: false),
    );
  }

  void updateDocument(DocumentOperationDocumentOption? value) {
    if (value == null ||
        !canSwitchSelectors ||
        value.id == _selectedDocument?.id) {
      return;
    }

    _selectedDocument = value;
    notifyListeners();
  }

  Future<void> initOrderList() async {
    _documents = await loadDocuments();
    _syncSelectedDocument(_documents);
    notifyListeners();
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

  Future<void> confirmOperation(BuildContext context) async {
    if (_selectedDocument == null) {
      FeedbackUtil.showInfo('请选择单据');
      return;
    }

    if (scannedTags.isEmpty) {
      FeedbackUtil.showInfo('暂无可操作数据');
      return;
    }

    if (requiresLocation && !locationReady) {
      FeedbackUtil.showInfo('请先扫描目标仓位');
      return;
    }

    final bool confirm = await DialogUtil.showConfirmDialog(
      content: '确认执行$orderLabel ${_selectedDocument!.no}吗？',
    );
    if (!confirm) {
      return;
    }
    FeedbackUtil.showLoading('提交中...');
    final req = <String, dynamic>{
      'no': _selectedDocument!.no,
      'tagNos': scannedTags.map((tag) => tag.tagNo).toList(),
      ...buildLocationParams(),
    };

    await submitOrder(req);
    FeedbackUtil.showSuccess('操作成功');
    scannedTags = <ProdTag>[];
    await clearCachedTags();
    notifyListeners();
  }
}
