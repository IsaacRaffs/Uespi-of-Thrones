import 'package:flutter/material.dart';

import '../models/game_save.dart';
import '../services/save_service.dart';
import 'guild_screen.dart';
import 'map_screen.dart';

class GameScreen extends StatefulWidget {
  final GameSave gameSave;

  const GameScreen({super.key, required this.gameSave});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int selectedIndex = 0;

  late GameSave save;

  @override
  void initState() {
    super.initState();
    save = widget.gameSave;
  }

  Future<void> saveProgress() async {
    save.updatedAt = DateTime.now();
    await SaveService.instance.save(save);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          GuildScreen(
            key: const ValueKey('guild'),
            save: save,
            onChanged: saveProgress,
          ),
          MapScreen(
            key: const ValueKey('map'),
            gameSave: save,
            onChanged: saveProgress,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.castle_outlined),
            selectedIcon: Icon(Icons.castle),
            label: 'Minha Guilda',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}
