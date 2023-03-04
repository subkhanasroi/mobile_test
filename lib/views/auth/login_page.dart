import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:test_youapp/common/data.dart';
import 'package:test_youapp/common/shared_data_type.dart';
import 'package:test_youapp/data/request.dart';
import 'package:test_youapp/data/sp_data.dart';
import 'package:test_youapp/models/app/user_model.dart';
import 'package:test_youapp/models/singleton_model.dart';
import 'package:test_youapp/views/auth/register_page.dart';
import 'package:test_youapp/views/profile/about_profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _isObscure;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _cEmail;
  late TextEditingController _cPassword;
  late bool _processLogIn;
  late Request _request;
  late SingletonModel _model;
  late SPData _data;

  @override
  void initState() {
    super.initState();
    _isObscure = false;
    _cEmail = TextEditingController();
    _cPassword = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _processLogIn = false;
    _model = SingletonModel.withContext(context);
    _request = Request();
    _data = SPData();
  }

  String? _validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  void _signIn() async {
    if (!_processLogIn) {
      if (_formKey.currentState!.validate()) {
        print("oja");
        print(_cEmail);
        print(_cPassword);
        setState(() {
          _processLogIn = true;
        });
        await _request.youApp.user
            .login(
          email: _cEmail.text,
          password: _cPassword.text,
        )
            .then((res) async {
          print(_cEmail.text);
          if (res.statusCode == 200 || res.statusCode == 201) {
            print(res.data);
            setState(() {
              // _cEmail.clear();
              // _cPassword.clear();
              _model.user = UserModel.fromJson(res.data);
              _model.token = res.data['access_token'];
              _data.saveToSP(kDUser, SharedDataType.string,
                  jsonEncode(_model.user!.toJson()));
            });
            _model.isLoggedIn = true;
            print("model data ${_model.user}}");
            print(_model.user!.toJson());
            print("Bja");
            await Future.delayed(const Duration(seconds: 2));
            Get.to(const AboutProfilePage());
          }
        }).catchError((e) {
          print("Cja");

          print(e);
          setState(() {
            // _cEmail.clear();
            // _cPassword.clear();
            _processLogIn = false;
          });
        });
      }
      setState(() {
        _processLogIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
              HexColor("1F4247"),
              HexColor("0D1D23"),
            ], center: Alignment.topRight, radius: 1)),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _cEmail,
                      validator: _validateEmail,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Enter username/email",
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password field is required';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      controller: _cPassword,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _isObscure,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: _isObscure == false
                              ? Icon(
                                  HeroIcons.eye,
                                  color: HexColor("#D1B000"),
                                )
                              : Icon(
                                  HeroIcons.eye_slash,
                                  color: HexColor("#D1B000"),
                                ),
                        ),
                        hintText: "Enter password",
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    MaterialButton(
                        onPressed: () => _signIn(),
                        height: 75,
                        padding: EdgeInsets.zero,
                        child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          HexColor("62CDCB").withOpacity(0.4),
                                      blurRadius: 2,
                                      offset: const Offset(0, 3))
                                ],
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    HexColor("#4599DB"),
                                    HexColor("#62CDCB"),
                                  ],
                                )),
                            child: Center(
                                child: _processLogIn
                                    ? const SpinKitCircle(
                                        size: 24,
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No account?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Get.to(const RegisterPage()),
                          child: Text(" Register here",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: HexColor("D1B000"),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
