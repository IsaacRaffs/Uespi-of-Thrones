import 'package:flutter/material.dart';

import '../data/guild_data.dart';
import '../models/guild.dart';
import '../services/save_service.dart';
import '../services/audio_service.dart';
import '../widgets/guild_crest.dart';
import 'game_screen.dart';

class _MedievalColors {
  static const background = Color(0xFF211B19);
  static const stone = Color(0xFF30251F);
  static const stoneLight = Color(0xFF45352A);
  static const gold = Color(0xFFD6AD55);
  static const parchment = Color(0xFFE8D2A5);
  static const parchmentDark = Color(0xFFB99863);
  static const ink = Color(0xFF352619);
  static const green = Color(0xFF527D49);
}

class CourseSelectionScreen extends StatefulWidget {
  final int slot;

  const CourseSelectionScreen({super.key, required this.slot});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  Guild? selectedGuild;
  bool creating = false;

  Widget attributeBar(String name, int value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: _MedievalColors.ink, size: 17),
          const SizedBox(width: 7),
          SizedBox(
            width: 82,
            child: Text(
              name,
              style: const TextStyle(
                color: _MedievalColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: (value / 100).clamp(0.0, 1.0),
                minHeight: 9,
                color: color,
                backgroundColor: const Color(0xFFC4AD80),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Text(
              '$value/100',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _MedievalColors.ink,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget guildCrest(Guild guild, {double size = 58}) {
    return GuildCrest(
      guildId: guild.id,
      size: size,
      fallbackIcon: guild.icon,
      fallbackColor: guild.color,
      frameColor: _MedievalColors.gold,
      backgroundColor: _MedievalColors.stone,
    );
  }

  Widget guildCard(Guild guild, int index) {
    final selected = selectedGuild?.id == guild.id;

    return GestureDetector(
      onTap: () {
        AudioService.instance.playClick();

        setState(() {
          selectedGuild = guild;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5A452C) : _MedievalColors.stone,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _MedievalColors.gold : const Color(0xFF705638),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.4 : 0.2),
              blurRadius: selected ? 9 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  guildCrest(guild),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CASA ${index + 1}',
                          style: const TextStyle(
                            color: _MedievalColors.gold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guild.name.toUpperCase(),
                          style: const TextStyle(
                            color: _MedievalColors.parchment,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guild.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? _MedievalColors.gold : Colors.white38,
                    size: 25,
                  ),
                ],
              ),
            ),
            Container(height: 1, color: const Color(0xFF705638)),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 13, 12),
              child: Column(
                children: [
                  attributeBar(
                    'Linguagens',
                    guild.attributes.literatura,
                    Colors.deepPurple,
                    Icons.menu_book,
                  ),
                  attributeBar(
                    'Exatas',
                    guild.attributes.exatas,
                    Colors.blue,
                    Icons.calculate,
                  ),
                  attributeBar(
                    'Natureza',
                    guild.attributes.natureza,
                    Colors.green,
                    Icons.eco,
                  ),
                  attributeBar(
                    'Humanas',
                    guild.attributes.humanas,
                    Colors.orange,
                    Icons.groups,
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: const BoxDecoration(
                  color: _MedievalColors.gold,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7),
                  ),
                ),
                child: const Text(
                  'CASA SELECIONADA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _MedievalColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> startGame() async {
    final guild = selectedGuild;

    if (guild == null || creating) return;

    setState(() {
      creating = true;
    });

    try {
      final game = await SaveService.instance.create(
        widget.slot,
        guild.id,
        literatura: guild.attributes.literatura,
        exatas: guild.attributes.exatas,
        natureza: guild.attributes.natureza,
        humanas: guild.attributes.humanas,
      );

      if (!mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GameScreen(gameSave: game)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _MedievalColors.stone,
          content: Text(
            'Erro ao criar jogo: $e',
            style: const TextStyle(color: _MedievalColors.parchment),
          ),
        ),
      );

      setState(() {
        creating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _MedievalColors.background,
      appBar: AppBar(
        backgroundColor: _MedievalColors.stone,
        foregroundColor: _MedievalColors.parchment,
        elevation: 5,
        title: Text(
          'ESCOLHA SUA CASA',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: _MedievalColors.gold),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 19, 18, 17),
            decoration: const BoxDecoration(
              color: _MedievalColors.stone,
              border: Border(
                bottom: BorderSide(color: _MedievalColors.gold, width: 2),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.castle, color: _MedievalColors.gold, size: 43),
                const SizedBox(height: 8),
                const Text(
                  'OS REINOS DE TERESINA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _MedievalColors.gold,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Escolha a guilda que representará seu reino. '
                  'Cada casa possui conhecimentos e características próprias.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _MedievalColors.parchment,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'ESPAÇO DE SALVAMENTO ${widget.slot}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 15),
              itemCount: guilds.length,
              itemBuilder: (context, index) {
                return guildCard(guilds[index], index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 14),
          decoration: const BoxDecoration(
            color: _MedievalColors.stone,
            border: Border(
              top: BorderSide(color: _MedievalColors.gold, width: 2),
            ),
          ),
          child: SizedBox(
            height: 53,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedGuild == null
                    ? Colors.grey.shade700
                    : _MedievalColors.gold,
                foregroundColor: _MedievalColors.ink,
                disabledBackgroundColor: Colors.grey.shade800,
                disabledForegroundColor: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: const BorderSide(
                    color: _MedievalColors.parchmentDark,
                    width: 1.5,
                  ),
                ),
              ),
              onPressed: selectedGuild == null || creating
                  ? null
                  : () {
                      AudioService.instance.playClick();
                      startGame();
                    },
              icon: creating
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _MedievalColors.ink,
                      ),
                    )
                  : const Icon(Icons.shield),
              label: Text(
                creating ? 'PREPARANDO SEU REINO...' : 'FUNDAR MEU REINO',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
