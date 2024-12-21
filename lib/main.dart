import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent AppBar background
          elevation: 0, // Remove AppBar shadow
          titleTextStyle: TextStyle(
            color: Colors.black, // Default text color
            fontSize: 18, // Default font size
          ),
        ),
      ),
      home: const Splashscreen(),
    );
  }
}

