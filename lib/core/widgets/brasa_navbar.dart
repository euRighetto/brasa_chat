import 'dart:ui';
import 'package:flutter/material.dart';

class BrasaNavbar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const BrasaNavbar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.white.withOpacity(.15),
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            color: Colors.black.withOpacity(.15),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item(Icons.dashboard_rounded, 0),
              _item(Icons.calendar_month_rounded, 1),
              _item(Icons.notifications_rounded, 2),
              _item(Icons.people_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, int i) {
    final active = index == i;

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? const Color(0xFF046A38)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 26,
          color: active ? Colors.white : Colors.white70,
        ),
      ),
    );
  }
}