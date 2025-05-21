import 'package:flutter/material.dart';
import 'dart:ui';
import 'Main/home_screen.dart';
import 'Berita/berita_screen.dart';
import 'toko/toko_screen.dart';
import 'detail_transaksi/detail.dart';
import 'Profil/profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const TokoScreen(),
    const BeritaScreen(),
    const DetailScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background dengan gradient + image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2ecc71), Color(0xFFF0FDF4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Tambahkan gambar background semi-transparan
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/background_pattern.png', // ganti sesuai gambar kamu
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur lembut
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: const SizedBox(),
            ),
          ),
          // Konten halaman dengan transisi
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
