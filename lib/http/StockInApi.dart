
import 'ApiClient.dart';

class StockInApi {

  StockInApi._();

  static const String _basePath = '/api/stock/in';

  static Future<dynamic> add(Map<String,dynamic> data){
    return ApiClient.instance.post(
      _basePath,
      data: data,
    );
  }

}