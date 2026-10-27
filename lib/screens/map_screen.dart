
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../models/guild.dart';
import '../services/battle_service.dart';
import '../services/save_service.dart';
import '../widgets/battle_ball.dart';
import '../widgets/guild_marker.dart';

class MapScreen extends StatefulWidget {
  final GameSave gameSave;

  const MapScreen({
    super.key,
    required this.gameSave,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final BattleService battleService = BattleService();

  late final List<Guild> gameGuilds;
  late final Guild playerGuild;

  Timer? battleTimer;
  bool saving = false;

  @override
  void initState() {
    super.initState();

    // Cria cópias independentes das guildas.
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

    playerGuild = gameGuilds.firstWhere(
      (g) => g.id == widget.gameSave.guildId,
    );

    playerGuild.coins = widget.gameSave.coins;
    playerGuild.books = widget.gameSave.books;
    playerGuild.bookshelves = widget.gameSave.bookshelves;
    playerGuild.shoes = widget.gameSave.shoes;
    playerGuild.health = widget.gameSave.health;

    battleTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => updateBattle(),
    );
  }

  void updateBattle() {
    if (!mounted || battleService.units.isEmpty) return;

    final arrived = <dynamic>[];

    for (final unit in battleService.units) {
      unit.progress += 0.004;

      if (unit.progress >= 1) {
        unit.progress = 1;
        arrived.add(unit);
      }
    }

    for (final unit in arrived) {
      final target = gameGuilds.firstWhere(
        (g) => g.id == unit.targetGuildId,
      );

      target.health = (target.health - 10).clamp(0, 1000);
      battleService.units.remove(unit);
    }

    setState(() {});

    if (arrived.any(
      (unit) => unit.targetGuildId == playerGuild.id,
    )) {
      saveProgress();
    }
  }

  Future<void> saveProgress() async {
    if (saving) return;
    saving = true;

    try {
      final oldSave = widget.gameSave;

      final updated = GameSave(
        slot: oldSave.slot,
        guildId: oldSave.guildId,
        createdAt: oldSave.createdAt,
        updatedAt: DateTime.now(),
        coins: playerGuild.coins,
        books: playerGuild.books,
        bookshelves: playerGuild.bookshelves,
        shoes: playerGuild.shoes,
        health: playerGuild.health,
      );

      await SaveService.instance.save(updated);
    } finally {
      saving = false;
    }
  }

  void showGuild(Guild guild) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final isPlayer = guild.id == playerGuild.id;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: guild.color,
                      child: Icon(
                        guild.icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        guild.name,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(guild.description),
                const SizedBox(height: 14),
                Text('Vida: ${guild.health}/1000'),
                Text('Coins: ${guild.coins}'),
                Text('Livros: ${guild.books}'),
                Text('Bancadas: ${guild.bookshelves}'),
                Text('Sapatos: ${guild.shoes}'),
                const SizedBox(height: 12),
                Text(
                  'Literatura: ${guild.attributes.literatura}/7',
                ),
                Text(
                  'Exatas: ${guild.attributes.exatas}/7',
                ),
                Text(
                  'Natureza: ${guild.attributes.natureza}/7',
                ),
                Text(
                  'Humanas: ${guild.attributes.humanas}/7',
                ),
                const SizedBox(height: 20),
                if (isPlayer)
                  const Text(
                    'Esta é a sua guilda.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: guild.isAlive &&
                              playerGuild.isAlive
                          ? () {
                              battleService.attack(
                                attacker: playerGuild,
                                target: guild,
                                amount: 15,
                              );

                              Navigator.pop(context);
                              setState(() {});
                            }
                          : null,
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text('ATACAR GUILDA'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> returnToMenu() async {
    await saveProgress();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    battleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) returnToMenu();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UESPI of Thrones'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: returnToMenu,
          ),
          actions: [
            Chip(
              avatar: Icon(
                playerGuild.icon,
                color: playerGuild.color,
              ),
              label: Text(playerGuild.name),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-5.0892, -42.8016),
            initialZoom: 12,
            minZoom: 10,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  'br.uespi.uespi_of_thrones',
            ),
            PolylineLayer(
              polylines: battleService.units
                  .where((unit) => unit.progress >= 0)
                  .map(
                    (unit) => Polyline(
                      points: [
                        unit.start,
                        unit.destination,
                      ],
                      strokeWidth: 2,
                      color: unit.color.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  )
                  .toList(),
            ),
            MarkerLayer(
              markers: gameGuilds.map((guild) {
                return Marker(
                  point: guild.location,
                  width: 120,
                  height: 75,
                  child: GuildMarker(
                    guild: guild,
                    onTap: () => showGuild(guild),
                  ),
                );
              }).toList(),
            ),
            MarkerLayer(
              markers: battleService.units
                  .where(
                    (unit) =>
                        unit.progress >= 0 &&
                        unit.progress <= 1,
                  )
                  .map(
                    (unit) => Marker(
                      point: unit.currentPosition,
                      width: 16,
                      height: 16,
                      child: BattleBall(
                        color: unit.color,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
