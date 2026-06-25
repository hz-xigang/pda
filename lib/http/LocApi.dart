
import 'package:dio/dio.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';

import 'ApiClient.dart';

class LocApi{

  LocApi._();

  static const String _basePath = '/api/loc';

  static Future<List<LocArchive>> list() async{
    final dynamic res = await ApiClient.instance.get(
      _basePath,
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    );
    return LocArchive.listFromDynamic(res);
  }

}