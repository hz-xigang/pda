import 'package:hz_xg_pda/entity/DocumentOperationDocumentOption.dart';
import 'package:hz_xg_pda/http/StockOrderApi.dart';
import 'package:hz_xg_pda/module_document_operation/base/base_document_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';

/// 调拨单（出/入库）
class TransferState extends BaseDocumentState {
  TransferState() : super();

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.transfer;

  @override
  int get tagFlag => 6;

  @override
  String get orderLabel => '调拨单（出/入库）';

  @override
  String get documentLabel => '选择调拨单号';

  @override
  String get apiCheckType => 'Transfer';

  @override
  Future<List<DocumentOperationDocumentOption>> loadDocuments() {
    return StockOrderApi.transferList();
  }

  @override
  Future<void> submitOrder(Map<String, dynamic> req) {
    return StockOrderApi.addTransfer(req);
  }
}

typedef TransferScope = NotifierScope<TransferState>;
