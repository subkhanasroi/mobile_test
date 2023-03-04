import 'dart:convert';

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
import 'package:test_youapp/views/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _isObscure1;
  late bool _isObscure2;
  late bool _processRegister;
  late GlobalKey<FormState> _formKey;
  late Request _request;
  late TextEditingController _cEmail;
  late TextEditingController _cUsername;
  late TextEditingController _cPassword;
  late TextEditingController _cCPassword;
  late SingletonModel _model;
  late SPData _data;

  @override
  void initState() {
    super.initState();
    _isObscure1 = false;
    _isObscure2 = false;
    _processRegister = false;
    _formKey = GlobalKey<FormState>();
    _request = Request();
    _model = SingletonModel.withContext(context);
    _data = SPData();
    _cEmail = TextEditingController();
    _cUsername = TextEditingController();
    _cPassword = TextEditingController();
    _cCPassword = TextEditingController();
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

  void _signUp() async {
    if (!_processRegister) {
      if (_formKey.currentState!.validate()) {
        if (_cPassword.text == _cCPassword.text) {
          setState(() {
            _processRegister = true;
          });
          await _request.youApp.user
              .register(
            email: _cEmail.text,
            username: _cUsername.text,
            password: _cPassword.text,
          )
              .then((res) async {
            print(_cEmail.text);
            if (res.statusCode == 200 || res.statusCode == 201) {
              print(res.data);
              // setState(() {
              //   // _cEmail.clear();
              //   // _cPassword.clear();
              // });
              print(res.data['data']);
              await Future.delayed(const Duration(seconds: 2));
              Get.to(const LoginPage());
            }
          });
          //     .catchError((e) {
          //   print("Cja");
          //
          //   print(e);
          //   setState(() {
          //     // _cEmail.clear();
          //     // _cPassword.clear();
          //     _processLogIn = false;
          //   });
          // });
        }
        setState(() {
          _processRegister = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Register',
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
                          hintText: "Enter email",
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _cUsername,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Create username",
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _cPassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password field is required';
                          }
                          if (value.trim().length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        obscureText: _isObscure1,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isObscure1 = !_isObscure1;
                              });
                            },
                            child: _isObscure1 == false
                                ? Icon(
                                    HeroIcons.eye,
                                    color: HexColor("#D1B000"),
                                  )
                                : Icon(
                                    HeroIcons.eye_slash,
                                    color: HexColor("#D1B000"),
                                  ),
                          ),
                          hintText: "Create password",
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _cCPassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password field is required';
                          }
                          if (value.trim().length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (_cPassword.text != _cCPassword.text) {
                            return "Password didn't match";
                          }
                          return null;
                        },
                        obscureText: _isObscure2,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            },
                            child: _isObscure2 == false
                                ? Icon(
                                    HeroIcons.eye,
                                    color: HexColor("#D1B000"),
                                  )
                                : Icon(
                                    HeroIcons.eye_slash,
                                    color: HexColor("#D1B000"),
                                  ),
                          ),
                          hintText: "Confirm password",
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      MaterialButton(
                          onPressed: () => _signUp(),
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
                                  child: _processRegister
                                      ? const SpinKitCircle(
                                          size: 24,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Register",
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
                            "Have account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () => Get.to(const LoginPage()),
                            child: Text(" Login here",
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
              ),
            )));
  }
}
