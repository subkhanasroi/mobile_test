import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:test_youapp/common/data.dart';
import 'package:test_youapp/common/image.dart';
import 'package:test_youapp/data/sp_data.dart';
import 'package:test_youapp/models/app/user_model.dart';
import 'package:test_youapp/views/auth/login_page.dart';
import 'package:test_youapp/views/profile/about_profile_page.dart';

import 'models/singleton_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late SPData _data;
  late SingletonModel _model;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _data = SPData();
    _model = SingletonModel.withContext(context);
    _progress = 0.0;
    _checkData();
  }

  void _checkData() async {
    String? user = await SPData.load(kDUser);
    _updateValue(.7);
    _model.isLoggedIn = user != null;
    if (_model.isLoggedIn) {
      _model.user = UserModel.fromJson(jsonDecode(user!));
      print("USER DATA ${jsonEncode(_model.user)}");
    }
    print(_model.user);

    await Future.delayed(const Duration(seconds: 1));
    Get.to(!_model.isLoggedIn ? const LoginPage() : const AboutProfilePage());
  }

  void _updateValue(double value) {
    setState(() {
      _progress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HexColor("1F4247"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 100,
              right: 100,
            ),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: HexColor("D2AD83"),
              valueColor: AlwaysStoppedAnimation<Color>(HexColor("D2AD83")),
              value: _progress,
            ),
          )
        ],
      ),
    );
  }
}
