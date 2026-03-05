import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/splash_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
       Get.find<SplashController>().jumpNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset(Images.appLogo)));
  }
}
