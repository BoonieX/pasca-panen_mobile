import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const CustomAppBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, //menghilangkan back button
      title: Row(
        children: [
          Image.asset('assets/logo_sementara.png', width: 40, height: 40),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              'Halo, $userName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Profil')));
            },
          ),
        ],
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
