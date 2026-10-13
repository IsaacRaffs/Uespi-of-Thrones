import 'package:flutter/material.dart';

class BattleBall extends StatelessWidget {
  final Color color;

  const BattleBall({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}