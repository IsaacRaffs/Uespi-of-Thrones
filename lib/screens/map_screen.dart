import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../models/guild.dart';
import '../models/battle_unit.dart';
import '../widgets/battle_ball.dart';
import '../widgets/guild_marker.dart';
import '../widgets/medieval_guild_marker.dart';
import 'battle_quiz_screen.dart';
import 'golden_diploma_screen.dart';
import '../data/course_questions.dart';
import '../services/opponent_service.dart';

import '../services/audio_service.dart';
import '../widgets/guild_crest.dart';

class MapScreen extends StatefulWidget {
  final GameSave gameSave;
  final Future<void> Function() onChanged;

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
    final isNext = nextOpponent?.id == target.id;
    final canDuelByLevel = save.level >= targetLevel;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF30251F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            border: Border(top: BorderSide(color: Color(0xFFD6AD55), width: 3)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6AD55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFF211B19),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD6AD55),
                      width: 3,
                    ),
                  ),
                  child: GuildCrest(
                    guildId: target.id,
                    size: 78,
                    fallbackIcon: target.icon,
                    fallbackColor: const Color(0xFFD6AD55),
                    framed: false,
                  ),
                ),

                const SizedBox(height: 13),

                Text(
                  target.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF1DEB5),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  target.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D2A5),
                    border: Border.all(
                      color: const Color(0xFFD6AD55),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _battleLevel('SUA GUILDA', save.level, Icons.castle),
                      const Icon(
                        Icons.sports_martial_arts,
                        color: Color(0xFF79451E),
                        size: 29,
                      ),
                      _battleLevel('ADVERSÁRIA', targetLevel, Icons.shield),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                if (isDefeated)
                  _battleMessage(
                    'TERRITÓRIO CONQUISTADO',
                    'Esta fortaleza já está sob seu domínio.',
                    const Color(0xFF527D49),
                  )
                else if (!isNext)
                  _battleMessage(
                    'TERRITÓRIO BLOQUEADO',
                    'Derrote a fortaleza anterior para avançar.',
                    const Color(0xFF922F2F),
                  )
                else if (!canDuelByLevel)
                  _battleMessage(
                    'NÍVEL INSUFICIENTE',
                    'Você precisa alcançar o nível $targetLevel para duelar. Seu nível atual: ${save.level}.',
                    const Color(0xFF922F2F),
                  )
                else
                  _battleMessage(
                    'PRÓXIMO ALVO',
                    'Prepare suas tropas para conquistar esta fortaleza.',
                    const Color(0xFF936B29),
                  ),

                const SizedBox(height: 18),

                if (isNext && !isDefeated && canDuelByLevel)
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B2929),
                        foregroundColor: const Color(0xFFFFE7B5),
                        side: const BorderSide(
                          color: Color(0xFFD6AD55),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: battling
                          ? null
                          : () {
                              Navigator.pop(context);
                              startBattle(target);
                            },
                      icon: const Icon(Icons.gavel),
                      label: const Text(
                        'DECLARAR GUERRA',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _battleLevel(String label, int level, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF79451E), size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF79451E),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'NÍVEL $level',
          style: const TextStyle(
            color: Color(0xFF352619),
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _battleMessage(String title, String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.17),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFF1DEB5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> startBattle(Guild target) async {
    if (battling) return;

    final targetLevel = getTargetLevel(target);
    if (save.level < targetLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nível insuficiente! Alcance o nível $targetLevel para duelar. (Seu nível: ${save.level})',
          ),
        ),
      );
      return;
    }

    final next = nextOpponent;

    if (next == null || next.id != target.id) {
      return;
    }

    final allQuestions = courseQuestions[target.id];

    if (allQuestions == null || allQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar as perguntas desta guilda.'),
        ),
      );
      return;
    }

    // A primeira batalha começa com 3 perguntas. Cada guilda inimiga
    // conquistada acrescenta uma pergunta à próxima batalha, até 16.
    final defeatedEnemyCount = gameGuilds
        .where((guild) => guild.id != save.guildId)
        .where((guild) => save.defeatedGuildIds.contains(guild.id))
        .length;
    final questionCount = (3 + defeatedEnemyCount).clamp(3, 16).toInt();
    final questions = allQuestions.take(questionCount).toList();
    final requiredCorrect = (questions.length * 2 + 2) ~/ 3;

    setState(() {
      battling = true;
      currentTarget = target;
    });

    final victory = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BattleQuizScreen(
          playerGuildId: playerGuild.id,
          opponentGuildId: target.id,
          opponentName: target.name,
          questions: questions,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      battling = false;
      currentTarget = null;
    });

    if (victory == true) {
      final alreadyDefeated = save.defeatedGuildIds.contains(target.id);

      if (!alreadyDefeated) {
        save.defeatedGuildIds.add(target.id);
        save.coins += 100 * getTargetLevel(target);
      }

      // A guilda do jogador não entra na contagem: são 14 adversárias.
      final enemyGuilds = gameGuilds.where((guild) => guild.id != save.guildId);
      final conqueredAllGuilds = enemyGuilds.every(
        (guild) => save.defeatedGuildIds.contains(guild.id),
      );
      final earnedDiploma = conqueredAllGuilds && !save.hasGoldenDiploma;

      if (earnedDiploma) {
        save.hasGoldenDiploma = true;
      }

      // Persiste a vitória, a recompensa em coins e a conquista no mesmo save.
      await widget.onChanged();

      if (!mounted) return;

      if (earnedDiploma) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const GoldenDiplomaScreen(),
        );
      } else {
        showResult(
          title: 'VITÓRIA!',
          message:
              'Você conquistou ${target.name}!\n\n'
              'Você acertou pelo menos $requiredCorrect das ${questions.length} perguntas.\n'
              '${alreadyDefeated ? 'Esta guilda já havia sido conquistada.' : 'Recompensa: ${100 * getTargetLevel(target)} coins.'}\n\n'
              '${conqueredAllGuilds ? 'Todas as guildas foram conquistadas!' : 'A próxima guilda já está disponível!'}',
          victory: true,
        );
      }
    } else if (victory == false) {
      showResult(
        title: 'DERROTA!',
        message:
            'Você não conseguiu conquistar ${target.name}.\n\n'
            'É necessário acertar pelo menos $requiredCorrect das ${questions.length} perguntas.\n\n'
            'Treine e tente novamente!',
        victory: false,
      );
    }

    if (mounted) {
      setState(() {});
    }
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
        final accent = victory
            ? const Color(0xFFD6AD55)
            : const Color(0xFFB94B45);

        return Dialog(
          backgroundColor: const Color(0xFF30251F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: accent, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  victory ? Icons.emoji_events : Icons.shield,
                  size: 75,
                  color: accent,
                ),

                const SizedBox(height: 12),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),

                const Divider(color: Color(0xFF80633C), height: 25),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF1DEB5),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                if (victory) ...[
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8D2A5),
                      border: Border.all(
                        color: const Color(0xFFD6AD55),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.inventory_2,
                          color: Color(0xFF79451E),
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'TESOURO CONQUISTADO',
                          style: TextStyle(
                            color: Color(0xFF352619),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: const Color(0xFF30251F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      victory
                          ? 'CONTINUAR CONQUISTANDO'
                          : 'RETORNAR À FORTALEZA',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        backgroundColor: const Color(0xFF30251C),
        foregroundColor: const Color(0xFFF1DEB5),
        elevation: 5,
        title: const Row(
          children: [
            Icon(Icons.castle, color: Color(0xFFD6AD55)),
            SizedBox(width: 10),
            Text(
              'REINO DE TERESINA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                'LV. ${save.level}',
                style: const TextStyle(
                  color: Color(0xFFD6AD55),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  // Vermelho
                  0.70, 0.38, 0.09, 0, 0,

                  // Verde
                  0.17, 0.84, 0.08, 0, 0,

                  // Azul
                  0.14, 0.27, 0.57, 0, 0,

                  // Transparência
                  0, 0, 0, 1, 0,
                ]),
                child: TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'br.uespi.uespi_of_thrones',
                ),
              ),

              PolylineLayer(
                polylines: units
                    .where((unit) => unit.progress >= 0)
                    .map(
                      (unit) => Polyline(
                        points: [unit.start, unit.destination],
                        color: const Color(0xFFC49A52).withValues(alpha: 0.65),
                        strokeWidth: 3,
                      ),
                    )
                    .toList(),
              ),

              MarkerLayer(
                markers: gameGuilds.map((guild) {
                  final defeated = save.defeatedGuildIds.contains(guild.id);

                  final isPlayer = guild.id == playerGuild.id;

                  final isNext = nextOpponent?.id == guild.id;

                  final level = isPlayer ? save.level : getTargetLevel(guild);

                  return Marker(
                    point: guild.location,
                    width: 126,
                    height: 105,
                    alignment: Alignment.topCenter,
                    child: MedievalGuildMarker(
                      guild: guild,
                      level: level,
                      isPlayer: isPlayer,
                      isDefeated: defeated,
                      isNext: isNext,
                      onTap: isPlayer ? () {} : () => showGuild(guild),
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

          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD6AD55).withValues(alpha: 0.65),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          if (nextOpponent != null)
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF30251C).withValues(alpha: 0.96),
                    border: Border.all(
                      color: const Color(0xFFD6AD55),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        color: Color(0xFFD6AD55),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PRÓXIMA CONQUISTA',
                              style: TextStyle(
                                color: Color(0xFFD6AD55),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              nextOpponent!.name,
                              style: const TextStyle(
                                color: Color(0xFFF1DEB5),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Fortaleza nível ${getTargetLevel(nextOpponent!)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => showGuild(nextOpponent!),
                        icon: const Icon(
                          Icons.sports_martial_arts,
                          color: Color(0xFFD6AD55),
                        ),
                        tooltip: 'Ver adversário',
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (battling)
            Positioned(
              left: 12,
              right: 12,
              bottom: 85,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF30251F).withValues(alpha: 0.97),
                  border: Border.all(color: const Color(0xFFD6AD55), width: 2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_martial_arts,
                          color: Color(0xFFD6AD55),
                        ),
                        SizedBox(width: 9),
                        Text(
                          'BATALHA EM ANDAMENTO',
                          style: TextStyle(
                            color: Color(0xFFD6AD55),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Suas tropas estão atacando ${currentTarget?.name ?? "a fortaleza"}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFF1DEB5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(
                      backgroundColor: Color(0xFF604B34),
                      color: Color(0xFFD6AD55),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF30251C).withValues(alpha: 0.96),
                  border: Border.all(
                    color: const Color(0xFFD6AD55),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MapLegendItem(
                      icon: Icons.castle,
                      label: 'Minha sede',
                      color: Color(0xFFD6AD55),
                    ),
                    _MapLegendItem(
                      icon: Icons.flag,
                      label: 'Adversária',
                      color: Color(0xFFBE4545),
                    ),
                    _MapLegendItem(
                      icon: Icons.shield,
                      label: 'Conquistada',
                      color: Color(0xFF63A56D),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLegendItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MapLegendItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF1DEB5),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
