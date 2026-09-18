import 'package:hz_xg_pda/entity/DocumentOperationDocumentOption.dart';
import 'package:hz_xg_pda/http/StockOrderApi.dart';
import 'package:hz_xg_pda/module_document_operation/base/base_document_state.dart';
import 'package:hz_xg_pda/provider/ProgTagCacheProvider.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';

/// 发货单（出库）
class ShipState extends BaseDocumentState {
  ShipState() : super();

  @override
  ProgTagCacheKey get cacheKey => ProgTagCacheKey.ship;

  @override
  int get tagFlag => 5;

  @override
  String get orderLabel => '发货单（出库）';

  @override
  String get documentLabel => '选择发货单号';

  @override
  String get apiCheckType => 'Ship';

  @override
  Future<List<DocumentOperationDocumentOption>> loadDocuments() {
    return StockOrderApi.shipList();
  }

  @override
  Future<void> submitOrder(Map<String, dynamic> req) {
    return StockOrderApi.addShip(req);
  }
}

typedef ShipScope = NotifierScope<ShipState>;
