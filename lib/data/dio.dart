import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:test_youapp/data/sp_data.dart';
import 'package:test_youapp/models/singleton_model.dart';

import 'api.dart';

class Dio {
  late d.Dio _dio;

  Dio({Map<String, dynamic>? headers}) {
    _dio = d.Dio();
    _dio.options = d.BaseOptions(
      baseUrl: API.baseUrl,
      connectTimeout: const Duration(seconds: 20000),
      receiveTimeout: const Duration(seconds: 20000),
      responseType: ResponseType.json,
      headers: headers ??
          {
            "Accept": "application/json",
            "Content-Type": "application/json",
            if (SingletonModel.shared.isLoggedIn)
              "Authorization":
                  "Bearer ${SingletonModel.shared.user!.accessToken}",
          },
    );
    _dio.interceptors.add(
      d.InterceptorsWrapper(
          onRequest: (d.RequestOptions o, d.RequestInterceptorHandler h) =>
              h.next(o),
          onResponse: (d.Response r, d.ResponseInterceptorHandler h) =>
              h.next(r),
          onError: (d.DioError e, d.ErrorInterceptorHandler h) async {
            if (e.response?.statusCode == 401) {
              SPData.reset();
              SingletonModel.shared.user = null;
              SingletonModel.shared.isLoggedIn = false;
            }
            return h.next(e);
          }),
    );
  }

  Future put({
    required String url,
    dynamic body,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.put(
        url,
        queryParameters: param,
        data: body,
      );
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on d.DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  Future post({
    required String url,
    dynamic body,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.post(
        url,
        queryParameters: param,
        data: body,
      );
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print(e);
        }
      }
      return Future.error(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on d.DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  Future get({
    required String url,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: param,
      );
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on d.DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  Future delete({
    required String url,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.delete(
        url,
        queryParameters: param,
      );
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    } on d.DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }
}
