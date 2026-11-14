import '../data/guild_data.dart';
import '../models/guild.dart';

class OpponentService {
  static List<Guild> getOpponents(String playerGuildId) {
    return guilds.where((guild) => guild.id != playerGuildId).toList();
  }

  static int getOpponentLevel(int opponentIndex) {
    return 10 + (opponentIndex * 5);
  }

  static Guild? getNextOpponent({
    required String playerGuildId,
    required List<String> defeatedGuildIds,
  }) {
    final opponents = getOpponents(playerGuildId);

    for (final opponent in opponents) {
      if (!defeatedGuildIds.contains(opponent.id)) {
        return opponent;
      }
    }

    return null;
  }

  static int getLevel({
    required String playerGuildId,
    required String opponentId,
  }) {
    final opponents = getOpponents(playerGuildId);

    final index = opponents.indexWhere((guild) => guild.id == opponentId);

    if (index < 0) return 0;

    return getOpponentLevel(index);
  }
}
