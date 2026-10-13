import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/guild_data.dart';
import '../models/guild.dart';
import '../services/battle_service.dart';
import '../widgets/battle_ball.dart';
import '../widgets/guild_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final BattleService battleService = BattleService();

  @override
  void initState() {
    super.initState();

    battleService.start(
      guilds: guilds,
      onUpdate: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void openGuild(Guild guild) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guild.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text('❤️ Vida: ${guild.health}'),
                  Text('🪙 Coins: ${guild.coins}'),
                  Text('📚 Livros: ${guild.books}'),
                  Text('🪑 Bancadas: ${guild.bookshelves}'),
                  Text('👟 Sapatos: ${guild.shoes}'),

                  const SizedBox(height: 25),

                  const Text(
                    'Atacar guilda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...guilds
                      .where((target) => target.id != guild.id)
                      .map(
                        (target) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: target.color,
                          ),
                          title: Text(target.name),
                          subtitle: Text(
                            'Vida: ${target.health}',
                          ),
                          trailing: const Icon(
                            Icons.gps_fixed,
                          ),
                          onTap: () {
                            battleService.attack(
                              attacker: guild,
                              target: target,
                              amount: 15,
                            );

                            Navigator.pop(context);

                            setState(() {});
                          },
                        ),
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UESPI of Thrones',
        ),
      ),

      body: FlutterMap(
        options: const MapOptions(
          // Centro aproximado de Teresina.
          initialCenter: LatLng(
            -5.0892,
            -42.8016,
          ),
          initialZoom: 13,
          minZoom: 11,
          maxZoom: 18,
        ),

        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

            userAgentPackageName:
                'br.uespi.uespi_of_thrones',
          ),

          // Rotas dos ataques
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
                      alpha: 0.25,
                    ),
                  ),
                )
                .toList(),
          ),

          // Guildas
          MarkerLayer(
            markers: guilds.map(
              (guild) {
                return Marker(
                  point: guild.location,
                  width: 120,
                  height: 75,
                  child: GuildMarker(
                    guild: guild,
                    onTap: () {
                      openGuild(guild);
                    },
                  ),
                );
              },
            ).toList(),
          ),

          // Exército se movimentando
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
    );
  }
}