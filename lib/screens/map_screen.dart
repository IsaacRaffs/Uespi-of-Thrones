import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../models/guild.dart';
import '../services/opponent_service.dart';
import '../models/battle_unit.dart';
import '../widgets/battle_ball.dart';
import '../widgets/guild_marker.dart';

class MapScreen extends StatefulWidget {
  final GameSave gameSave;
  final VoidCallback onChanged;

  const MapScreen({super.key, required this.gameSave, required this.onChanged});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final List<Guild> gameGuilds;
  late final Guild playerGuild;

  final List<BattleUnit> units = [];

  Timer? battleTimer;

  bool battling = false;

  Guild? currentTarget;

  GameSave get save => widget.gameSave;

  @override
  void initState() {
    super.initState();

    gameGuilds = guilds.map((g) {
      return Guild(
        id: g.id,
        name: g.name,
        description: g.description,
        location: g.location,
        color: g.color,
        icon: g.icon,
        attributes: g.attributes,
      );
    }).toList();

    playerGuild = gameGuilds.firstWhere((g) => g.id == save.guildId);
  }

  Guild? get nextOpponent {
    return OpponentService.getNextOpponent(
      playerGuildId: save.guildId,
      defeatedGuildIds: save.defeatedGuildIds,
    );
  }

  int getTargetLevel(Guild target) {
    return OpponentService.getLevel(
      playerGuildId: save.guildId,
      opponentId: target.id,
    );
  }

  void showGuild(Guild target) {
    final targetLevel = getTargetLevel(target);

    final isDefeated = save.defeatedGuildIds.contains(target.id);

    final next = nextOpponent;

    final isNext = next?.id == target.id;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: target.color,
                      child: Icon(target.icon, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        target.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text('Nível da guilda: $targetLevel'),
                Text('Seu nível: ${save.level}'),

                const SizedBox(height: 12),

                if (isDefeated)
                  const Text(
                    'Guilda conquistada!',
                    style: TextStyle(color: Colors.green),
                  )
                else if (!isNext)
                  const Text(
                    'Esta guilda ainda não está disponível. '
                    'Derrote a guilda anterior primeiro.',
                  )
                else
                  const Text(
                    'Esta é sua próxima adversária!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                const SizedBox(height: 18),

                if (isNext && !isDefeated)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: battling
                          ? null
                          : () {
                              Navigator.pop(context);
                              startBattle(target);
                            },
                      icon: const Icon(Icons.sports_martial_arts),
                      label: const Text('INICIAR BATALHA'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void startBattle(Guild target) {
    if (battling) return;

    if (save.level < getTargetLevel(target)) {
      showDefeat(target);
      return;
    }

    setState(() {
      battling = true;
      currentTarget = target;
      units.clear();
    });

    for (int i = 0; i < 15; i++) {
      units.add(
        BattleUnit(
          id: '${DateTime.now().microsecondsSinceEpoch}-$i',
          attackerGuildId: playerGuild.id,
          targetGuildId: target.id,
          start: playerGuild.location,
          destination: target.location,
          color: playerGuild.color,
          progress: -(i * 0.035),
        ),
      );
    }

    battleTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      for (final unit in units) {
        unit.progress += 0.012;
      }

      units.removeWhere((unit) => unit.progress >= 1);

      setState(() {});

      if (units.isEmpty) {
        timer.cancel();
        finishBattle(target);
      }
    });
  }

  void finishBattle(Guild target) {
    final enemyLevel = getTargetLevel(target);

    final victory = save.level >= enemyLevel;

    setState(() {
      battling = false;
      currentTarget = null;
    });

    if (victory) {
      save.defeatedGuildIds.add(target.id);

      save.coins += 100 * enemyLevel;

      widget.onChanged();

      showResult(
        title: 'VITÓRIA!',
        message:
            'Você conquistou ${target.name}!\n'
            'Recompensa: ${100 * enemyLevel} coins.',
        victory: true,
      );
    } else {
      showDefeat(target);
    }
  }

  void showDefeat(Guild target) {
    setState(() {
      battling = false;
      units.clear();
      currentTarget = null;
    });

    showResult(
      title: 'DERROTA!',
      message:
          'Sua guilda foi derrotada por ${target.name}.\n\n'
          'Seu nível: ${save.level}\n'
          'Nível adversário: ${getTargetLevel(target)}\n\n'
          'Treine sua guilda e tente novamente!',
      victory: false,
    );
  }

  void showResult({
    required String title,
    required String message,
    required bool victory,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('VOLTAR AO JOGO'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    battleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Teresina'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: Text('Nível ${save.level}')),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-5.0892, -42.8016),
              initialZoom: 12,
              minZoom: 10,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'br.uespi.uespi_of_thrones',
              ),

              PolylineLayer(
                polylines: units
                    .where((unit) => unit.progress >= 0)
                    .map(
                      (unit) => Polyline(
                        points: [unit.start, unit.destination],
                        color: unit.color.withValues(alpha: 0.25),
                        strokeWidth: 2,
                      ),
                    )
                    .toList(),
              ),

              MarkerLayer(
                markers: gameGuilds.map((guild) {
                  final defeated = save.defeatedGuildIds.contains(guild.id);

                  final isPlayer = guild.id == playerGuild.id;

                  return Marker(
                    point: guild.location,
                    width: 120,
                    height: 75,
                    child: Opacity(
                      opacity: defeated ? 0.55 : 1,
                      child: GuildMarker(
                        guild: guild,
                        onTap: isPlayer ? () {} : () => showGuild(guild),
                      ),
                    ),
                  );
                }).toList(),
              ),

              MarkerLayer(
                markers: units
                    .where((unit) => unit.progress >= 0 && unit.progress <= 1)
                    .map(
                      (unit) => Marker(
                        point: unit.currentPosition,
                        width: 16,
                        height: 16,
                        child: BattleBall(color: unit.color),
                      ),
                    )
                    .toList(),
              ),

              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          if (nextOpponent != null)
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.flag, color: Colors.amber),
                  title: const Text(
                    'PRÓXIMA CONQUISTA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${nextOpponent!.name} · '
                    'Nível ${getTargetLevel(nextOpponent!)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showGuild(nextOpponent!),
                ),
              ),
            ),

          if (battling)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    '⚔️ Atacando ${currentTarget?.name}...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
