
import 'ApiClient.dart';

class StockInApi {

  StockInApi._();

  static const String _basePath = '/api/stock/in';

  /// [type] 0=普通入库, 1=退货入库（对应后端 StockInController 的 type 参数）
  static Future<dynamic> add(Map<String,dynamic> data, {int type = 0}){
    return ApiClient.instance.post(
      _basePath,
      data: data,
      queryParameters: {'type': type},
    );
  }

}