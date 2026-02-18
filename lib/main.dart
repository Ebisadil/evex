import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/login_page.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/onboarding.dart';

import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/tab.dart';
import 'feature/featurdemo/auth/presentation/screen/splash.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evex',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: {
        '/onboarding': (context) => Onboarding(),
        '/login': (context) => LoginPage(),
        '/home': (context) => MainBottomNav(),
      },
    );
  }
}
