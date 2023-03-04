import 'package:dio/dio.dart' as dio;
import 'package:test_youapp/data/api.dart';
import 'package:test_youapp/data/dio.dart';

late API _api;
late Dio _dio;

class Repo {
  late _YouApp youApp;

  Repo() {
    _api = API();
    _dio = Dio();
    youApp = _YouApp();
  }
}

class _YouApp {
  _User user = _User();
}

class _User {
  Future<dio.Response> register({required Map<String, dynamic> data}) async {
    return await _dio.post(url: _api.youApp.user.register, body: data);
  }

  Future<dio.Response> login({required Map<String, dynamic> data}) async {
    return await _dio.post(url: _api.youApp.user.login, body: data);
  }

  Future<dio.Response> update(
      {required Map<String, dynamic> data, required String id}) async {
    return await _dio.put(url: _api.youApp.user.update(id), body: data);
  }

  Future<dio.Response> updatePhoto(
      {dio.FormData? data, required String id}) async {
    return await _dio.put(url: _api.youApp.user.updatePhoto(id), body: data);
  }
}
