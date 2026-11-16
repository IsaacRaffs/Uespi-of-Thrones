import 'dart:async';

import '../models/battle_unit.dart';
import '../models/guild.dart';

class BattleService {
  final List<BattleUnit> units = [];

  Timer? _timer;

  bool get isRunning => _timer?.isActive ?? false;

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
          progress: -(i * 0.03),
        ),
      );
    }
  }

  void start({required void Function() onUpdate, required List<Guild> guilds}) {
    if (_timer?.isActive ?? false) return;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final arrivedUnits = <BattleUnit>[];

      for (final unit in units) {
        unit.progress += 0.004;

        if (unit.progress >= 1) {
          unit.progress = 1;
          arrivedUnits.add(unit);
        }
      }

      for (final unit in arrivedUnits) {
        final targetIndex = guilds.indexWhere(
          (guild) => guild.id == unit.targetGuildId,
        );

        if (targetIndex != -1) {
          guilds[targetIndex].health -= 10;
        }

        units.remove(unit);
      }

      onUpdate();

      if (units.isEmpty) {
        timer.cancel();
        _timer = null;
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
    units.clear();
  }
}
