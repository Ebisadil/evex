import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/onboarding.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Onboarding()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/icon.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
