import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final List<_NavItem> _items = const [
  _NavItem(icon: Icons.home, label: 'Home'),       // index 0
  _NavItem(icon: Icons.article, label: 'Berita'),  // index 1
  _NavItem(icon: Icons.store, label: 'Toko'),      // index 2
  _NavItem(icon: Icons.history, label: 'History'), // index 3
  _NavItem(icon: Icons.person, label: 'Profile'),  // index 4
];


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double itemWidth = size.width / _items.length;

    return Stack(
      children: [
        // Background dengan lekukan
        CustomPaint(
          size: Size(size.width, 80),
          painter: ConvexPainter(selectedIndex: currentIndex, itemWidth: itemWidth),
        ),
        // Tombol-tombol
        SizedBox(
          height: 80,
          child: Row(
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(top: isSelected ? 8 : 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            height: index == 2 ? 50 : 36,
                            width: index == 2 ? 50 : 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 2
                                  ? (isSelected
                                      ? Colors.orange
                                      : Colors.orangeAccent.shade100)
                                  : Colors.transparent,
                              gradient: index == 2
                                  ? const LinearGradient(
                                      colors: [Color(0xFFFF7E5F), Color(0xFFFFB88C)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      const BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              item.icon,
                              color: index == 2 ? Colors.white : (isSelected ? Colors.orange : Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.black : Colors.black54,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ConvexPainter extends CustomPainter {
  final int selectedIndex;
  final double itemWidth;

  ConvexPainter({required this.selectedIndex, required this.itemWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path path = Path();
    final double centerX = selectedIndex * itemWidth + itemWidth / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - 40, 0);
    path.quadraticBezierTo(centerX - 35, 0, centerX - 35, 20);
    path.quadraticBezierTo(centerX, 60, centerX + 35, 20);
    path.quadraticBezierTo(centerX + 35, 0, centerX + 40, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}


