import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/pages/history_screen.dart';
import 'package:pascapanen_mobile/pages/home_screen.dart';
import 'package:pascapanen_mobile/pages/product_screen.dart';
import 'package:pascapanen_mobile/pages/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _indexTerpilih = 0;

  final List<Widget> _daftarHalaman = [
    const HomeScreen(),
    const ProductScreen(),
    const HistoryScreen(),
    ProfileScreen(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _daftarHalaman[_indexTerpilih],

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.time_to_leave),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _indexTerpilih,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _indexTerpilih = index;
          });
        },
      ),
    );
  }
}
