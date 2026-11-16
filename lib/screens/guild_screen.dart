import 'package:flutter/material.dart';

import 'dart:math' as math;

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../services/progression_service.dart';
import '../widgets/guild_crest.dart';

class MedievalStyle {
  static const background = Color(0xFF211B19);
  static const stone = Color(0xFF30251F);
  static const stoneLight = Color(0xFF45352A);
  static const gold = Color(0xFFD6AD55);
  static const parchment = Color(0xFFE8D2A5);
  static const parchmentDark = Color(0xFFB99863);
  static const ink = Color(0xFF352619);
  static const green = Color(0xFF527D49);
  static const red = Color(0xFF922F2F);
}

class GuildScreen extends StatefulWidget {
  final GameSave save;
  final VoidCallback onChanged;

  const GuildScreen({super.key, required this.save, required this.onChanged});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _altarRotationController;

  @override
  void initState() {
    super.initState();

    _altarRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    _altarRotationController.dispose();
    super.dispose();
  }

  bool clicking = false;

  GameSave get save => widget.save;

  String get courseName {
    return guilds.firstWhere((g) => g.id == save.guildId).name;
  }

  Widget parchmentPanel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: MedievalStyle.parchment,
        border: Border.all(color: MedievalStyle.gold, width: 2),
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 7, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: MedievalStyle.gold, size: 22),
        const SizedBox(width: 9),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: MedievalStyle.parchment,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }

  Widget resourceItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: MedievalStyle.gold, size: 27),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: MedievalStyle.parchment,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget attributeRow(String name, int value, Color color, IconData icon) {
    final normalizedValue = (value / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: MedievalStyle.ink, size: 21),
          const SizedBox(width: 9),
          SizedBox(
            width: 88,
            child: Text(
              name,
              style: const TextStyle(
                color: MedievalStyle.ink,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: normalizedValue,
                minHeight: 11,
                backgroundColor: const Color(0xFFC4AD80),
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            '$value/100',
            style: const TextStyle(
              color: MedievalStyle.ink,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TREINAMENTO
  // =========================================================

  Future<void> train() async {
    if (clicking) return;
    _altarRotationController.forward(from: 0);
    setState(() {
      clicking = true;
    });

    try {
      // Só adiciona XP se ainda não houver uma evolução pendente.
      if (!ProgressionService.canLevelUp(save)) {
        ProgressionService.addExperience(save);
        widget.onChanged();
      }

      // Verifica se a guilda alcançou o próximo nível.
      if (ProgressionService.canLevelUp(save)) {
        await Future.delayed(const Duration(milliseconds: 300));

        if (!mounted) return;

        await showUpgradeDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          clicking = false;
        });

        widget.onChanged();
      }
    }
  }

  // =========================================================
  // ESPECIALIZAÇÕES
  // =========================================================

  Future<void> showUpgradeDialog() async {
    final options = [
      (
        'xp',
        'Treinamento aprimorado',
        'Aumenta o XP recebido por clique.',
        Icons.touch_app,
        '+1 XP por clique',
        true,
      ),
      (
        'hints',
        'Sabedoria estratégica',
        'Concede uma nova dica para o jogador.',
        Icons.lightbulb,
        '+1 dica',
        true,
      ),
      (
        'knowledge',
        'Conhecimento acadêmico',
        'Amplia o conhecimento geral da guilda.',
        Icons.menu_book,
        '+5 conhecimento',
        save.guildKnowledge < 100,
      ),
      (
        'literatura',
        'Linguagens',
        'Aprimora a capacidade de comunicação.',
        Icons.menu_book,
        '${save.literatura}/100 → ${save.literatura + 1}/100',
        save.literatura < 100,
      ),
      (
        'exatas',
        'Exatas',
        'Aprimora o raciocínio lógico e matemático.',
        Icons.calculate,
        '${save.exatas}/100 → ${save.exatas + 1}/100',
        save.exatas < 100,
      ),
      (
        'natureza',
        'Natureza',
        'Aprimora o conhecimento das ciências naturais.',
        Icons.eco,
        '${save.natureza}/100 → ${save.natureza + 1}/100',
        save.natureza < 100,
      ),
      (
        'humanas',
        'Humanas',
        'Aprimora o conhecimento social e histórico.',
        Icons.groups,
        '${save.humanas}/100 → ${save.humanas + 1}/100',
        save.humanas < 100,
      ),
    ];

    final chosen = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: MedievalStyle.parchment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: MedievalStyle.gold, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Color(0xFF966B25),
                  size: 52,
                ),
                const SizedBox(height: 8),
                const Text(
                  'PONTO DE ESPECIALIZAÇÃO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MedievalStyle.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Sua guilda alcançou o nível ${save.level + 1}. '
                  'Escolha onde investir seu ponto:',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MedievalStyle.ink,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((option) {
                        final available = option.$6;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: available
                                ? const Color(0xFFD7BD8B)
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(7),
                            child: ListTile(
                              dense: true,
                              enabled: available,
                              leading: Icon(
                                option.$4,
                                color: MedievalStyle.ink,
                              ),
                              title: Text(
                                option.$2,
                                style: const TextStyle(
                                  color: MedievalStyle.ink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.$3,
                                    style: const TextStyle(
                                      color: MedievalStyle.ink,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    available
                                        ? option.$5
                                        : 'Limite máximo atingido',
                                    style: const TextStyle(
                                      color: MedievalStyle.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: available
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      color: MedievalStyle.green,
                                    )
                                  : const Icon(
                                      Icons.lock,
                                      color: Colors.black45,
                                    ),
                              onTap: available
                                  ? () {
                                      Navigator.pop(dialogContext, option.$1);
                                    }
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || chosen == null) return;

    final success = ProgressionService.applySpecialization(save, chosen);

    if (success) {
      widget.onChanged();
      setState(() {});
    }
  }

  // =========================================================
  // CONSTRUÇÃO DA TELA
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final xpLimit = ProgressionService.xpRequired(save.level);

    final progress = (save.experience / xpLimit).clamp(0.0, 1.0);

    final remainingXp = (xpLimit - save.experience).clamp(0, xpLimit);

    final knowledgeProgress = (save.guildKnowledge / 100).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: MedievalStyle.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(17, 16, 17, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================================
              // IDENTIDADE DA GUILDA
              // =================================================

              const Text(
                'SALÃO DA FORTALEZA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MedievalStyle.gold,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: GuildCrest(
                  guildId: save.guildId,
                  size: 116,
                  fallbackIcon: Icons.castle,
                  frameColor: MedievalStyle.gold,
                  backgroundColor: MedievalStyle.stone,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                courseName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MedievalStyle.parchment,
                  fontWeight: FontWeight.w900,
                  fontSize: 23,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 9),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: MedievalStyle.stoneLight,
                    border: Border.all(color: MedievalStyle.gold, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'NÍVEL ${save.level}',
                    style: const TextStyle(
                      color: MedievalStyle.gold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 27),

              // =================================================
              // EXPERIÊNCIA
              // =================================================
              sectionTitle('Experiência da guilda', Icons.auto_awesome),

              const SizedBox(height: 12),

              parchmentPanel(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PROGRESSO',
                          style: TextStyle(
                            color: MedievalStyle.ink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${save.experience} / $xpLimit XP',
                          style: const TextStyle(
                            color: MedievalStyle.ink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 17,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C7756),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: MedievalStyle.ink),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF98702E), Color(0xFFFFD77A)],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      '$remainingXp treinamentos restantes',
                      style: const TextStyle(
                        color: MedievalStyle.ink,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 27),

              // =================================================
              // ALTAR DE TREINAMENTO
              // =================================================
              sectionTitle('Altar de treinamento', Icons.auto_awesome),

              const SizedBox(height: 8),

              const Text(
                'Fortaleça sua guilda através do conhecimento.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: clicking ? null : train,
                  child: AnimatedScale(
                    scale: clicking ? 0.91 : 1,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutBack,
                    child: AnimatedBuilder(
                      animation: _altarRotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _altarRotationController.value * 2 * math.pi,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 175,
                        height: 175,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0xFFFFE6A0),
                              Color(0xFFC18A39),
                              Color(0xFF54351F),
                            ],
                          ),
                          border: Border.all(
                            color: MedievalStyle.gold,
                            width: 5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x99FFD700),
                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 22,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 67,
                              color: Color(0xFF493019),
                            ),
                            Text(
                              '+${save.xpPerClick} XP',
                              style: const TextStyle(
                                color: Color(0xFF493019),
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'TOQUE NO ALTAR PARA TREINAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MedievalStyle.gold,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 29),

              // =================================================
              // CONHECIMENTOS
              // =================================================
              sectionTitle('Conhecimentos da guilda', Icons.menu_book),

              const SizedBox(height: 12),

              parchmentPanel(
                child: Column(
                  children: [
                    attributeRow(
                      'Linguagens',
                      save.literatura,
                      Colors.deepPurple,
                      Icons.menu_book,
                    ),
                    attributeRow(
                      'Exatas',
                      save.exatas,
                      Colors.blue.shade800,
                      Icons.calculate,
                    ),
                    attributeRow(
                      'Natureza',
                      save.natureza,
                      Colors.green.shade800,
                      Icons.eco,
                    ),
                    attributeRow(
                      'Humanas',
                      save.humanas,
                      Colors.brown,
                      Icons.groups,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 27),

              // =================================================
              // TESOURO
              // =================================================
              sectionTitle('Tesouro da guilda', Icons.inventory_2),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: MedievalStyle.stone,
                  border: Border.all(color: MedievalStyle.gold, width: 1.5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    resourceItem(
                      Icons.monetization_on,
                      '${save.coins}',
                      'Coins',
                    ),
                    Container(width: 1, height: 55, color: Colors.white24),
                    resourceItem(Icons.menu_book, '${save.books}', 'Livros'),
                  ],
                ),
              ),

              const SizedBox(height: 27),

              // =================================================
              // DESENVOLVIMENTO DA GUILDA
              // =================================================
              sectionTitle('Desenvolvimento da guilda', Icons.auto_awesome),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MedievalStyle.stone,
                  border: Border.all(color: MedievalStyle.gold, width: 1.5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  children: [
                    // XP por clique
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'XP POR CLIQUE',
                          style: TextStyle(
                            color: MedievalStyle.parchment,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+${save.xpPerClick} XP',
                          style: const TextStyle(
                            color: MedievalStyle.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(color: Colors.white24),

                    // Dicas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DICAS DISPONÍVEIS',
                          style: TextStyle(
                            color: MedievalStyle.parchment,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${save.hints}',
                          style: const TextStyle(
                            color: MedievalStyle.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Conhecimento geral
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CONHECIMENTO GERAL',
                          style: TextStyle(
                            color: MedievalStyle.parchment,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${save.guildKnowledge}/100',
                          style: const TextStyle(
                            color: MedievalStyle.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: knowledgeProgress,
                        minHeight: 10,
                        backgroundColor: Colors.black45,
                        color: MedievalStyle.gold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // RODAPÉ
              // =================================================
              const Text(
                'O conhecimento é a maior força de um reino.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MedievalStyle.parchmentDark,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
