import 'package:flutter/material.dart';

import '../models/guild.dart';

class GuildMarker extends StatelessWidget {
  final Guild guild;
  final VoidCallback onTap;

  const GuildMarker({
    super.key,
    required this.guild,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: guild.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black54,
                ),
              ],
            ),
            child: const Icon(
              Icons.castle,
              color: Colors.white,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            color: Colors.black87,
            child: Text(
              guild.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}