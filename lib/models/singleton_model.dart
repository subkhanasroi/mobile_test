import 'package:flutter/material.dart';
import 'package:test_youapp/models/app/interest_model.dart';
import 'package:test_youapp/models/app/user_model.dart';

class SingletonModel {
  static SingletonModel? _singleton;

  factory SingletonModel() => _singleton ?? SingletonModel._internal();

  SingletonModel._internal();

  static SingletonModel withContext(BuildContext context) {
    _singleton ??= SingletonModel._internal();
    _singleton!.context = context;

    return _singleton!;
  }

  static SingletonModel get shared => _singleton ?? SingletonModel._internal();

  late bool isLoggedIn;
  UserModel? user;
  String? token;
  Data? data;
  BuildContext? context;
  List<String>? interest;
}
