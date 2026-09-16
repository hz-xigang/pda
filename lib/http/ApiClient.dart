import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hz_xg_pda/entity/response_dto.dart';
import 'package:hz_xg_pda/http/ApiException.dart';
import 'package:hz_xg_pda/provider/TokenProvider.dart';
import 'package:hz_xg_pda/util/dialog_util.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  factory ApiClient() => instance;

  static final String baseUrl = kDebugMode
      ? 'http://192.168.1.100:7100/'
      : 'http://175.178.92.52/';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: Headers.formUrlEncodedContentType,
    ),
  );

  Dio get dio => _dio;
  /// 将 DioException 转换为友好的中文提示信息
  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接服务器超时，请检查网络或稍后重试';
      case DioExceptionType.sendTimeout:
        return '请求发送超时，请检查网络';
      case DioExceptionType.receiveTimeout:
        return '服务器响应超时，请稍后重试';
      case DioExceptionType.connectionError:
        final underlyingError = e.error;
        if (underlyingError is SocketException) {
          final osError = underlyingError.osError;
          final errorCode = osError?.errorCode;
          // 常见错误码：10061/111(拒绝连接 Connection refused), 10060/110(连接超时 ETIMEDOUT), 101/10051(网络不可达 Network unreachable)
          if (errorCode == 10061 || errorCode == 111) {
            return '无法连接到服务器，请确认服务已启动或地址正确';
          }
          return '网络连接失败，请检查网络设置或是否已连接 WiFi/蜂窝移动网络';
        }
        return '无法连接到服务器，请检查网络设置';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return '请求参数错误 (400)';
            case 401:
              return '登录已过期或未授权，请重新登录';
            case 403:
              return '没有权限访问该资源 (403)';
            case 404:
              return '请求的服务接口不存在 (404)';
            case 500:
            case 502:
            case 503:
            case 504:
              return '服务器内部错误或维护中 ($statusCode)';
            default:
              return '服务器响应异常 ($statusCode)';
          }
        }
        return '服务器响应异常';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.badCertificate:
        return '证书验证失败';
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return '网络连接失败，请检查网络或稍后重试';
        }
        return '网络请求失败，请稍后重试';
    }
  }



  Future<dynamic> request({
    required String url,
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showDefaultAlert = true,
    void Function(ApiException exception)? onError,
  }) async {
    try {
      // final Map<String, dynamic> tokenHeaders = await TokenProvider.buildTokenHeaders();
      final loginUser = await TokenProvider.getLoginUser();

      final response = await _dio.request<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(
          method: method,
          headers: {
            // ...tokenHeaders,
            "Authorization" :   "Bearer ${loginUser?.token.trim().isNotEmpty == true
                ? loginUser!.token.trim()
                : ''}",
            ...?options?.headers,
          },
        ),
      );

      final dynamic decodedData = _decodeResponseData(response.data);
      if (decodedData is! Map) {
        throw ApiException(
          message: '响应格式错误',
          statusCode: response.statusCode,
          rawResponse: decodedData,
        );
      }

      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
        decodedData,
      );

      final ResponseDto resp = ResponseDto.fromJson(jsonMap);

      if (!resp.success) {
        final exception = ApiException(
          message: resp.message.isEmpty ? '请求失败' : resp.message,
          statusCode: response.statusCode,
          code: resp.code,
          data: resp.data,
          rawResponse: jsonMap,
        );
        onError?.call(exception);
        if (showDefaultAlert) {
          DialogUtil.showAlert(content:  resp.message.isEmpty ? '请求失败' : resp.message);
        }
        throw exception;
      }

      return resp.data;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      final chineseMessage = _getDioErrorMessage(e);
      final exception = ApiException(
        message: chineseMessage,
        statusCode: e.response?.statusCode,
        rawResponse: e.response?.data,
      );
      onError?.call(exception);
      if (showDefaultAlert) {
        DialogUtil.showAlert(content: chineseMessage);
      }
      debugPrint('DioException on $url: $e');
      throw exception;
    } on FormatException catch (e) {
      final exception = ApiException(
        message: '数据解析失败: ${e.message}',
        rawResponse: e.source,
      );
      onError?.call(exception);
      if (showDefaultAlert) {
        DialogUtil.showAlert(content: '数据解析失败: ${e.message}');
      }
      throw exception;
    } catch (e) {
      final exception = ApiException(
        message: '未知异常: $e',
      );
      onError?.call(exception);
      debugPrint('Exception on $url: $e');
      if (showDefaultAlert) {
        DialogUtil.showAlert(content: '未知异常: $e');
      }
      throw exception;
    }
  }

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showDefaultAlert = true,
    void Function(ApiException exception)? onError,
  }) {
    return request(
      url: url,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      showDefaultAlert: showDefaultAlert,
      onError: onError,
    );
  }

  Future<dynamic> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showDefaultAlert = true,
    void Function(ApiException exception)? onError,
  }) {
    options ??= Options(
      contentType: Headers.jsonContentType,
    );

    return request(
      url: url,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      showDefaultAlert: showDefaultAlert,
      onError: onError,
    );
  }

  Future<dynamic> put(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showDefaultAlert = true,
    void Function(ApiException exception)? onError,
  }) {
    return request(
      url: url,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      showDefaultAlert: showDefaultAlert,
      onError: onError,
    );
  }

  Future<dynamic> delete(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showDefaultAlert = true,
    void Function(ApiException exception)? onError,
  }) {
    return request(
      url: url,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      showDefaultAlert: showDefaultAlert,
      onError: onError,
    );
  }

  dynamic _decodeResponseData(dynamic rawData) {
    if (rawData is String) {
      return jsonDecode(rawData);
    }
    return rawData;
  }
}
