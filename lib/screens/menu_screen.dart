
import 'package:flutter/material.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../services/save_service.dart';
import 'course_selection_screen.dart';
import 'map_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<GameSave?> saves = [null, null, null];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refreshSaves();
  }

  Future<void> refreshSaves() async {
    setState(() => loading = true);

    try {
      final result = await SaveService.instance.loadAll();
      if (!mounted) return;
      setState(() => saves = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao ler saves: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openSlots({required bool newGame}) async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                newGame ? 'Novo jogo' : 'Continuar jogo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...List.generate(3, (index) {
                final slot = index + 1;
                final game = saves[index];
                final enabled = newGame
                    ? game == null
                    : game != null;

                final guildName = game == null
                    ? 'Slot vazio'
                    : guilds
                        .where((g) => g.id == game.guildId)
                        .map((g) => g.name)
                        .firstOrNull ?? 'Curso desconhecido';

                return Card(
                  child: ListTile(
                    enabled: enabled,
                    leading: const Icon(Icons.save),
                    title: Text('Save $slot'),
                    subtitle: Text(guildName),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: enabled
                        ? () => Navigator.pop(context, slot)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );

    if (chosen == null || !mounted) return;

    if (newGame) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CourseSelectionScreen(
            slot: chosen,
          ),
        ),
      );
    } else {
      final game = await SaveService.instance.load(chosen);
      if (!mounted || game == null) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(gameSave: game),
        ),
      );
    }

    if (mounted) await refreshSaves();
  }

  @override
  Widget build(BuildContext context) {
    final hasSave = saves.any((save) => save != null);

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.castle,
                  size: 110,
                  color: Colors.amber,
                ),
                const SizedBox(height: 24),
                const Text(
                  'UESPI OF THRONES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Conquiste territórios. Domine Teresina.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 60),
                if (loading)
                  const CircularProgressIndicator()
                else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => openSlots(newGame: true),
                      icon: const Icon(Icons.add),
                      label: const Text('NOVO JOGO'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: hasSave
                          ? () => openSlots(newGame: false)
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('CONTINUAR'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
