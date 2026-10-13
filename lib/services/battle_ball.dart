import 'dart:async';

import '../models/battle_unit.dart';
import '../models/guild.dart';

class BattleService {
  final List<BattleUnit> units = [];

  void attack({
    required Guild attacker,
    required Guild target,
    int amount = 10,
  }) {
    for (int i = 0; i < amount; i++) {
      units.add(
        BattleUnit(
          id: '${DateTime.now().microsecondsSinceEpoch}-$i',
          attackerGuildId: attacker.id,
          targetGuildId: target.id,
          start: attacker.location,
          destination: target.location,
          color: attacker.color,

          // Faz as unidades saírem em momentos ligeiramente diferentes.
          progress: -(i * 0.03),
        ),
      );
    }
  }

  void start({
    required void Function() onUpdate,
    required List<Guild> guilds,
  }) {
    Timer.periodic(
      const Duration(milliseconds: 50),
      (_) {
        final arrivedUnits = <BattleUnit>[];

        for (final unit in units) {
          unit.progress += 0.004;

          if (unit.progress >= 1) {
            unit.progress = 1;
            arrivedUnits.add(unit);
          }
        }

        for (final unit in arrivedUnits) {
          final target = guilds.firstWhere(
            (guild) => guild.id == unit.targetGuildId,
          );

          target.health -= 10;

          units.remove(unit);
        }

        onUpdate();
      },
    );
  }
}