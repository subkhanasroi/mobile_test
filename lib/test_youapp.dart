import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_youapp/splash_page.dart';

class TestYouApp extends StatelessWidget {
  const TestYouApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8)),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintStyle: const TextStyle(color: Colors.white)),
          textTheme: GoogleFonts.interTextTheme(textTheme)),
      home: const SplashPage(),
    );
  }
}
