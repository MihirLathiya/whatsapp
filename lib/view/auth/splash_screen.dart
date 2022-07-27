import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/auth/mobile_screen.dart';
import 'package:whatsapp/view/common/colors.dart';
import 'package:whatsapp/view/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Get.offAll(
          () => storage.read('name') == null ? MobileScreen() : HomeScreen(),
          transition: Transition.leftToRight),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: 60,
                width: 60,
                color: AppColors.mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
