import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pascapanen_mobile/screens/login_page.dart';
import 'package:pascapanen_mobile/pages/splash/splash_screen.dart';
import 'package:pascapanen_mobile/pages/main_screen.dart';

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

    // Fade in logo
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Setelah 3 detik, tentukan ke mana harus navigasi
    Future.delayed(const Duration(seconds: 3), () {
      _navigateNext();
    });
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final lastLoginStr = prefs.getString('last_login');

    if (!mounted) return;

    if (token == null || lastLoginStr == null) {
      // Belum pernah login ⇒ tampilkan splash kedua
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    } else {
      // Sudah pernah login ⇒ cek kadaluwarsa (2 menit)
      final lastLogin = DateTime.tryParse(lastLoginStr);
      final now = DateTime.now();

      if (lastLogin != null && now.difference(lastLogin).inMinutes <= 2) {
        // Token masih aktif ⇒ langsung ke MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        // Token kadaluarsa ⇒ hapus data login & ke LoginPage
        await prefs.remove('token');
        await prefs.remove('last_login');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
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
