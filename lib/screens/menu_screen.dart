import 'package:flutter/material.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../services/save_service.dart';
import 'course_selection_screen.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<GameSave?> saves = [null, null, null];
  bool loading = true;

  static const Color background = Color(0xFF071426);
  static const Color gold = Color(0xFFD6AD55);
  static const Color goldLight = Color(0xFFFFE6A0);
  static const Color stone = Color(0xFF211B19);
  static const Color parchment = Color(0xFFE8D2A5);

  @override
  void initState() {
    super.initState();
    refreshSaves();
  }

  // =========================================================
  // ATUALIZAÇÃO DOS SAVES
  // =========================================================

  Future<void> refreshSaves() async {
    setState(() => loading = true);

    try {
      final result = await SaveService.instance.loadAll();

      if (!mounted) return;

      setState(() {
        saves = result;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao ler saves: $e')));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // =========================================================
  // EXCLUIR PARTIDA
  // =========================================================

  Future<void> confirmDelete(int slot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: parchment,
          title: const Text(
            'Excluir partida?',
            style: TextStyle(
              color: stone,
              fontFamily: 'UnifrakturCook',
              fontSize: 25,
            ),
          ),
          content: Text(
            'Você realmente deseja apagar o Save $slot?\n\n'
            'Todo o progresso dessa partida será perdido.',
            style: const TextStyle(color: stone, fontFamily: 'MedievalSharp'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar', style: TextStyle(color: stone)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Apagar save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await SaveService.instance.delete(slot);

    if (!mounted) return;

    await refreshSaves();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: stone,
        content: Text(
          'Save $slot apagado com sucesso.',
          style: const TextStyle(color: parchment, fontFamily: 'MedievalSharp'),
        ),
      ),
    );
  }

  // =========================================================
  // SELEÇÃO DOS SLOTS
  // =========================================================

  Future<void> openSlots({required bool newGame}) async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: parchment,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  newGame ? 'Novo jogo' : 'Continuar jogo',
                  style: const TextStyle(
                    fontFamily: 'UnifrakturCook',
                    fontSize: 32,
                    color: stone,
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(color: gold),
                const SizedBox(height: 12),

                ...List.generate(3, (index) {
                  final slot = index + 1;
                  final game = saves[index];

                  final enabled = newGame ? game == null : game != null;

                  final guildName = game == null
                      ? 'Slot vazio'
                      : guilds
                                .where((g) => g.id == game.guildId)
                                .map((g) => g.name)
                                .firstOrNull ??
                            'Curso desconhecido';

                  return Card(
                    color: const Color(0xFFD7BD8B),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: const BorderSide(color: gold, width: 1.5),
                    ),
                    child: ListTile(
                      enabled: enabled,
                      leading: Icon(
                        game == null ? Icons.save_outlined : Icons.castle,
                        color: stone,
                        size: 30,
                      ),
                      title: Text(
                        'Save $slot',
                        style: const TextStyle(
                          color: stone,
                          fontFamily: 'UnifrakturCook',
                          fontSize: 23,
                        ),
                      ),
                      subtitle: Text(
                        guildName,
                        style: const TextStyle(
                          color: stone,
                          fontFamily: 'MedievalSharp',
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (game != null)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: 'Apagar save',
                              onPressed: () {
                                confirmDelete(slot);
                              },
                            ),
                          Icon(
                            Icons.chevron_right,
                            color: enabled ? stone : Colors.black26,
                          ),
                        ],
                      ),
                      onTap: enabled
                          ? () {
                              Navigator.pop(sheetContext, slot);
                            }
                          : null,
                    ),
                  );
                }),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    if (chosen == null || !mounted) return;

    // NOVA PARTIDA
    if (newGame) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CourseSelectionScreen(slot: chosen)),
      );
    }
    // CONTINUAR PARTIDA
    else {
      final game = await SaveService.instance.load(chosen);

      if (!mounted || game == null) return;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GameScreen(gameSave: game)),
      );
    }

    if (mounted) {
      await refreshSaves();
    }
  }

  // =========================================================
  // BOTÃO MEDIEVAL
  // =========================================================

  Widget medievalButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: primary
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'MedievalSharp',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: stone,
                disabledBackgroundColor: Colors.grey.shade800,
                disabledForegroundColor: Colors.white38,
                elevation: 7,
                side: const BorderSide(color: goldLight, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'MedievalSharp',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: gold,
                disabledForegroundColor: Colors.white30,
                side: const BorderSide(color: gold, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
    );
  }

  // =========================================================
  // TELA PRINCIPAL
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final hasSave = saves.any((save) => save != null);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // FUNDO DA TELA
          Image.asset('assets/images/background_menu.png', fit: BoxFit.cover),

          // CAMADA ESCURA SUAVE
          Container(color: Colors.black.withValues(alpha: 0.18)),

          // CONTEÚDO DO MENU
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 40 : 24,
                          vertical: 20,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // LOGOTIPO TRANSPARENTE
                              Image.asset(
                                'assets/images/uespi_logo_transparente.png',
                                width: isWide ? 560 : double.infinity,
                                height: isWide ? 390 : 300,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(height: 8),

                              // FRASE
                              const Text(
                                'CONQUISTE TERRITÓRIOS. DOMINE TERESINA.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: goldLight,
                                  fontSize: 13,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MedievalSharp',
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 8),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 35),

                              // BOTÕES
                              if (loading)
                                const CircularProgressIndicator(color: gold)
                              else
                                SizedBox(
                                  width: isWide ? 380 : double.infinity,
                                  child: Column(
                                    children: [
                                      medievalButton(
                                        label: 'NOVO JOGO',
                                        icon: Icons.add,
                                        primary: true,
                                        onPressed: () {
                                          openSlots(newGame: true);
                                        },
                                      ),

                                      const SizedBox(height: 16),

                                      medievalButton(
                                        label: 'CONTINUAR',
                                        icon: Icons.play_arrow,
                                        onPressed: hasSave
                                            ? () {
                                                openSlots(newGame: false);
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 35),

                              // RODAPÉ
                              const Text(
                                'AD SCIENTIAM INVESTIGANDUM',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontFamily: 'MedievalSharp',
                                ),
                              ),

                              const SizedBox(height: 12),

                              const Text(
                                'UESPI OF THRONES',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
