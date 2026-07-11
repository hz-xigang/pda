

import '../entity/DocumentOperationDocumentOption.dart';
import 'ApiClient.dart';




class StockOrderApi {

  StockOrderApi._();

  static String _baseUrl(String type) =>
      "/api/$type/order";


  static Future<List<DocumentOperationDocumentOption>> _list(
      String type,
      String field,
      ) async {

    final res =
    await ApiClient.instance.get(_baseUrl(type));

    return res.map<DocumentOperationDocumentOption>(
          (e) => DocumentOperationDocumentOption(
        id: e["id"],
        no: e[field],
      ),
    ).toList();
  }


  static Future<List<DocumentOperationDocumentOption>> shipList() =>
      _list("ship", "shipNo");


  static Future<List<DocumentOperationDocumentOption>> prepList() =>
      _list("prep", "prepNo");


  static Future<List<DocumentOperationDocumentOption>> transferList() =>
      _list("transfer", "orderNo");


}