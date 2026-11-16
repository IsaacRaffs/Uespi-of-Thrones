import '../data/guild_data.dart';
import '../models/guild.dart';

class OpponentService {
  /// Retorna todas as guildas adversárias na ordem de conquista.
  static List<Guild> getOpponents(String playerGuildId) {
    return guilds
        .where((guild) => guild.id != playerGuildId)
        .toList(growable: false);
  }

  /// A primeira adversária começa no nível 10.
  /// Cada adversária seguinte recebe mais 5 níveis.
  static int getOpponentLevel(int opponentIndex) {
    if (opponentIndex < 0) return 0;
    return 10 + (opponentIndex * 5);
  }

  /// Retorna a primeira guilda ainda não derrotada.
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

  /// Retorna o nível de uma adversária específica.
  static int getLevel({
    required String playerGuildId,
    required String opponentId,
  }) {
    final opponents = getOpponents(playerGuildId);

    final index = opponents.indexWhere((guild) => guild.id == opponentId);

    return getOpponentLevel(index);
  }

  /// Verifica se a guilda pode ser atacada neste momento.
  static bool isNextOpponent({
    required String playerGuildId,
    required String opponentId,
    required List<String> defeatedGuildIds,
  }) {
    final next = getNextOpponent(
      playerGuildId: playerGuildId,
      defeatedGuildIds: defeatedGuildIds,
    );

    return next?.id == opponentId;
  }

  /// Verifica se todas as adversárias foram conquistadas.
  static bool hasConqueredAll({
    required String playerGuildId,
    required List<String> defeatedGuildIds,
  }) {
    return getNextOpponent(
          playerGuildId: playerGuildId,
          defeatedGuildIds: defeatedGuildIds,
        ) ==
        null;
  }
}
