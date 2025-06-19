import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/home/home_main.dart';
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/utils/shared_pref.dart';
import '../onboarding/omboarding.dart';
import '../utils/screen_size.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    try {
      bool isIntro = await PrefData.getIntro();
      bool isLogin = await PrefData.getLogin();

      Timer(const Duration(seconds: 3), () {
        if (!isIntro) {
          Get.off(() => const SlidePage()); // Fresh install, go to onboarding
        } else if (!isLogin) {
          Get.off(() => const EmptyState()); // Intro shown, not logged in, go to login
        } else {
          Get.off(() => const HomeMainScreen()); // Intro shown, logged in, go to main screen
        }
      });
    } catch (e) {
      Timer(const Duration(seconds: 3), () {
        Get.off(() => const EmptyState()); // Fallback to login screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 140.h,
              width: 140.h,
              child: const Image(
                image: AssetImage("assets/ceflogo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "CEF Online",
            style: TextStyle(
              fontSize: 32.sp,
              color: const Color(0XFF8cc13f),
              fontFamily: 'AvenirLTPro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}