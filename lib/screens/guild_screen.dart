import 'package:flutter/material.dart';

import '../data/guild_data.dart';
import '../models/game_save.dart';
import '../services/progression_service.dart';

class GuildScreen extends StatefulWidget {
  final GameSave save;
  final VoidCallback onChanged;

  const GuildScreen({super.key, required this.save, required this.onChanged});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen> {
  bool clicking = false;

  GameSave get save => widget.save;

  String get courseName {
    return guilds.firstWhere((g) => g.id == save.guildId).name;
  }

  Future<void> train() async {
    if (clicking || ProgressionService.canLevelUp(save)) return;

    setState(() => clicking = true);

    ProgressionService.addExperience(save);

    if (ProgressionService.canLevelUp(save)) {
      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await showUpgradeDialog();
    }

    if (!mounted) return;

    widget.onChanged();

    setState(() => clicking = false);
  }

  Future<void> showUpgradeDialog() async {
    final chosen = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final options = [
          ('literatura', 'Linguagens', Icons.menu_book, save.literatura),
          ('exatas', 'Exatas', Icons.calculate, save.exatas),
          ('natureza', 'Natureza', Icons.eco, save.natureza),
          ('humanas', 'Humanas', Icons.groups, save.humanas),
        ];

        return AlertDialog(
          title: const Text('NOVA EVOLUÇÃO!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 65),
              const SizedBox(height: 12),
              Text('Sua guilda alcançou o nível ${save.level + 1}!'),
              const SizedBox(height: 16),
              const Text('Escolha um atributo para melhorar:'),
              const SizedBox(height: 12),
              ...options.map((option) {
                final available = option.$4 < 7;

                return Card(
                  child: ListTile(
                    enabled: available,
                    leading: Icon(
                      option.$3,
                      color: available ? null : Colors.grey,
                    ),
                    title: Text(option.$2),
                    subtitle: Text(
                      available
                          ? '${option.$4} → ${option.$4 + 1}'
                          : 'Nível máximo atingido',
                    ),
                    trailing: available
                        ? const Icon(Icons.arrow_upward)
                        : const Icon(Icons.lock),
                    onTap: available
                        ? () => Navigator.pop(context, option.$1)
                        : null,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (chosen == null) return;

    final success = ProgressionService.upgradeAttribute(save, chosen);

    if (success) {
      widget.onChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Guilda evoluiu para o nível ${save.level}!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget attributeBar(String name, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 95, child: Text(name)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 7,
              color: color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Text('$value/7'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final xpLimit = ProgressionService.xpRequired(save.level);
    final progress = save.experience / xpLimit;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.castle, color: Colors.white, size: 48),
              ),

              const SizedBox(height: 12),

              Text(
                courseName,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Chip(
                avatar: const Icon(Icons.military_tech, color: Colors.amber),
                label: Text('NÍVEL ${save.level}'),
              ),

              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EXPERIÊNCIA DA GUILDA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${save.experience} XP'),
                          Text('$xpLimit XP'),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 15,
                          color: Colors.amber,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${xpLimit - save.experience} cliques para evoluir',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'CENTRO DE TREINAMENTO',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Treine sua guilda para conquistar experiência.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              GestureDetector(
                onTap: train,
                child: AnimatedScale(
                  scale: clicking ? 0.90 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFFE0B84F),
                          Color(0xFF9660C9),
                          Color(0xFF33204F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 65),
                        Text(
                          '+1 XP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'TOQUE PARA TREINAR',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ATRIBUTOS DA GUILDA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              const SizedBox(height: 12),

              attributeBar('Linguagens', save.literatura, Colors.purple),
              attributeBar('Exatas', save.exatas, Colors.blue),
              attributeBar('Natureza', save.natureza, Colors.green),
              attributeBar('Humanas', save.humanas, Colors.orange),

              const SizedBox(height: 20),

              Text('Coins: ${save.coins} | Livros: ${save.books}'),
            ],
          ),
        ),
      ),
    );
  }
}
