import 'package:flutter/material.dart';

import '../models/guild.dart';
import 'guild_crest.dart';

class MedievalGuildMarker extends StatelessWidget {
  final Guild guild;
  final VoidCallback onTap;

  final bool isPlayer;
  final bool isDefeated;
  final bool isNext;
  final int level;

  const MedievalGuildMarker({
    super.key,
    required this.guild,
    required this.onTap,
    required this.level,
    this.isPlayer = false,
    this.isDefeated = false,
    this.isNext = false,
  });

  static const Color gold = Color(0xFFD6AD55);
  static const Color parchment = Color(0xFFE8D2A5);
  static const Color darkStone = Color(0xFF29231D);

  @override
  Widget build(BuildContext context) {
    final Color bannerColor = isDefeated ? Colors.green.shade800 : guild.color;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 116,
        height: 94,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Brasão e castelo
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 51,
                  height: 51,
                  decoration: BoxDecoration(
                    color: darkStone,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      color: isNext ? Colors.amber : gold,
                      width: isNext ? 3 : 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GuildCrest(
                    guildId: guild.id,
                    size: 47,
                    framed: false,
                    fallbackIcon: Icons.castle,
                    fallbackColor: isDefeated ? Colors.green.shade300 : gold,
                  ),
                ),

                // Bandeira da guilda
                Positioned(
                  top: -8,
                  right: -9,
                  child: Container(
                    width: 22,
                    height: 27,
                    decoration: BoxDecoration(
                      color: bannerColor,
                      border: Border.all(color: gold, width: 1.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),

                if (isPlayer)
                  Positioned(
                    left: -8,
                    top: -8,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber.shade300,
                      size: 19,
                    ),
                  ),

                if (isNext)
                  Positioned(
                    bottom: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A2020),
                        border: Border.all(color: gold, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'ALVO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 5),

            // Placa medieval com nome e nível
            Container(
              constraints: const BoxConstraints(maxWidth: 116),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: parchment,
                border: Border.all(color: gold, width: 1.3),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 4),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    guild.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF352619),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isDefeated ? 'CONQUISTADA' : 'NÍVEL $level',
                    style: TextStyle(
                      color: isDefeated
                          ? Colors.green.shade900
                          : const Color(0xFF79451E),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
