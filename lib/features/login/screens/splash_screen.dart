import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ebsar2/core/di/di.dart';
import 'package:ebsar2/core/utils/pref.dart';
import 'package:ebsar2/features/login/screens/welcome_screen.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Scaffold(
        backgroundColor: const Color(0xFFFADC52),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/lotties/app_logo.png',
                height: 250,
                width: 250,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFADC52),
      nextScreen: sl<MySharedPref>().getString(key: MySharedKeys.token) != ''
          ? const FirstScreen(isComeAgain: true,)
          : const WelcomeScreen(),
      splashIconSize: 600,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
