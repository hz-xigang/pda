
import 'ApiClient.dart';

class StockMoveApi {

  StockMoveApi._();

  static const String _basePath = '/api/stock/move';

  static Future<dynamic> add(Map<String,dynamic> data){
    return ApiClient.instance.post(
      _basePath,
      data: data,
    );
  }

}