import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:test_youapp/data/repo.dart';

late Repo _repo;

class Request {
  late _YouApp youApp;

  Request() {
    _repo = Repo();
    youApp = _YouApp();
  }
}

class _YouApp {
  _User user = _User();
}

class _User {
  Future<dio.Response> register(
      {required String username,
      required String email,
      required String password}) {
    return _repo.youApp.user.register(data: {
      "username": username,
      "email": email,
      "password": password,
    });
  }

  Future<dio.Response> login({
    required String email,
    required String password,
  }) {
    return _repo.youApp.user
        .login(data: {"email": email, "password": password});
  }

  Future<dio.Response> updatePhoto({
    File? image,
    String? id,
  }) async {
    Map<String, dynamic> map = {};
    if (image != null) {
      map["file"] = await dio.MultipartFile.fromFile(
        image.path,
        filename: image.path.split("/").last,
      );
    }
    return _repo.youApp.user
        .updatePhoto(id: id!, data: dio.FormData.fromMap(map));
  }

  Future<dio.Response> update({
    String? id,
    String? displayName,
    String? gender,
    String? birthday,
    String? zodiac,
    String? shio,
    String? height,
    String? weight,
  }) async {
    print(id);
    print({
      "display_name": displayName,
      "gender": gender,
      "birthday": birthday,
      "zodiac": zodiac,
      "height": height,
      "weight": weight
    });

    return _repo.youApp.user.update(id: id!, data: {
      "display_name": displayName,
      "gender": gender,
      "birthday": birthday,
      "zodiac": zodiac,
      "shio": shio,
      "height": height,
      "weight": weight
    });
  }
}
