
import 'package:flutter/material.dart';

import '../data/guild_data.dart';
import '../models/guild.dart';
import '../services/save_service.dart';
import 'map_screen.dart';

class CourseSelectionScreen extends StatefulWidget {
  final int slot;

  const CourseSelectionScreen({
    super.key,
    required this.slot,
  });

  @override
  State<CourseSelectionScreen> createState() =>
      _CourseSelectionScreenState();
}

class _CourseSelectionScreenState
    extends State<CourseSelectionScreen> {
  Guild? selectedGuild;
  bool creating = false;

  Widget attributeBar(
    String name,
    int value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 7,
              minHeight: 9,
              color: color,
              backgroundColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Text('$value/7'),
        ],
      ),
    );
  }

  Widget courseCard(Guild guild) {
    final selected = selectedGuild?.id == guild.id;

    return Card(
      color: selected ? guild.color.withValues(alpha: 0.15) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? guild.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() => selectedGuild = guild);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: guild.color,
                    child: Icon(
                      guild.icon,
                      color: Colors.white,
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      guild.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle,
                      color: guild.color,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(guild.description),
              const SizedBox(height: 14),
              attributeBar(
                'Literatura',
                guild.attributes.literatura,
                Colors.purple,
              ),
              attributeBar(
                'Exatas',
                guild.attributes.exatas,
                Colors.blue,
              ),
              attributeBar(
                'Natureza',
                guild.attributes.natureza,
                Colors.green,
              ),
              attributeBar(
                'Humanas',
                guild.attributes.humanas,
                Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startGame() async {
    final guild = selectedGuild;
    if (guild == null || creating) return;

    setState(() => creating = true);

    try {
      final game = await SaveService.instance.create(
        widget.slot,
        guild.id,
      );

      if (!mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(gameSave: game),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar jogo: $e')),
      );
      setState(() => creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha seu curso — Save ${widget.slot}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: guilds.length,
        itemBuilder: (context, index) {
          return courseCard(guilds[index]);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: selectedGuild == null || creating
                ? null
                : startGame,
            icon: const Icon(Icons.sports_esports),
            label: Text(
              creating
                  ? 'CRIANDO PARTIDA...'
                  : 'INICIAR JOGO',
            ),
          ),
        ),
      ),
    );
  }
}
