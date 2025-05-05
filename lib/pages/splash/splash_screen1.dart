import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/screens/login_page.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade in
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Fade out setelah 2 detik
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    // Pindah ke splash berikutnya setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 248, 248),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          child: Image.asset(
            'assets/logo_splash.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
