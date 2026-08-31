
import 'package:dio/dio.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';

import 'ApiClient.dart';
import 'ApiException.dart';

class PalletApi {

  PalletApi._();

  static const String _basePath = '/api/pallet';

  static Future<dynamic> add(List<String> data){
    return ApiClient.instance.post(
      _basePath,
      data: data,
    );
  }


  static Future<List<ProdTag>> findTagsByPallet(
      String palletNo,
      int type,
      void Function(ApiException exception)? onError) async
  {
    dynamic res = await ApiClient.instance.get(
      '$_basePath/tags/$palletNo?type=$type',
        onError: onError
    );
    print(res);
    return ProdTag.listFromDynamic(res);
  }

  /// 拆托：将指定标签从托盘中移除
  static Future<dynamic> unbundle(String palletNo, List<String> tagNos) {
    return ApiClient.instance.post(
      '$_basePath/unbundle/$palletNo',
      data: tagNos,
    );
  }

}