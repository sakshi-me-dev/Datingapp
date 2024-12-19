import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customButton({
  required IconData icon,
  required Color color,
  double size = 50,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    ),
  );
}
