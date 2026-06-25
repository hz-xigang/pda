
import 'package:dio/dio.dart';

import 'ApiClient.dart';

class PalletApi {

  PalletApi._();

  static const String _basePath = '/api/pallet';

  static Future<dynamic> add(List<String> data){
    return ApiClient.instance.post(
      _basePath,
      data: data,
    );

  }

}