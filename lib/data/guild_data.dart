
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/guild.dart';

final List<Guild> guilds = [
  Guild(
    id: 'psicologia',
    name: 'Psicologia',
    description:
        'Especialistas na mente humana, empatia e estratégia social.',
    location: const LatLng(-5.0892, -42.8016),
    color: Colors.purple,
    icon: Icons.psychology,
    attributes: const GuildAttributes(
      literatura: 4, exatas: 2, natureza: 5, humanas: 7,
    ),
  ),
  Guild(
    id: 'engenharia_civil',
    name: 'Engenharia Civil',
    description:
        'Construtores de fortalezas e especialistas em estruturas.',
    location: const LatLng(-5.0755, -42.7890),
    color: Colors.orange,
    icon: Icons.architecture,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 7, natureza: 6, humanas: 3,
    ),
  ),
  Guild(
    id: 'engenharia_eletrica',
    name: 'Engenharia Elétrica',
    description:
        'Dominam a energia, circuitos e tecnologias elétricas.',
    location: const LatLng(-5.1020, -42.8150),
    color: Colors.amber,
    icon: Icons.bolt,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 7, natureza: 7, humanas: 2,
    ),
  ),
  Guild(
    id: 'zootecnia',
    name: 'Zootecnia',
    description:
        'Conhecedores dos animais, da criação e dos recursos naturais.',
    location: const LatLng(-5.0600, -42.8100),
    color: Colors.brown,
    icon: Icons.pets,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 4, natureza: 7, humanas: 5,
    ),
  ),
  Guild(
    id: 'historia',
    name: 'História',
    description:
        'Guardiões da memória, das civilizações e dos acontecimentos.',
    location: const LatLng(-5.0950, -42.7900),
    color: Colors.deepOrange,
    icon: Icons.history_edu,
    attributes: const GuildAttributes(
      literatura: 6, exatas: 1, natureza: 4, humanas: 7,
    ),
  ),
  Guild(
    id: 'medicina',
    name: 'Medicina',
    description:
        'Especialistas em cura, sobrevivência e conhecimento do corpo.',
    location: const LatLng(-5.0850, -42.8200),
    color: Colors.red,
    icon: Icons.medical_services,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 4, natureza: 7, humanas: 5,
    ),
  ),
  Guild(
    id: 'fisica',
    name: 'Física',
    description:
        'Investigadores das leis do universo, movimento e energia.',
    location: const LatLng(-5.1100, -42.8050),
    color: Colors.indigo,
    icon: Icons.science,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 7, natureza: 7, humanas: 2,
    ),
  ),
  Guild(
    id: 'educacao_fisica',
    name: 'Educação Física',
    description:
        'Guerreiros da resistência, do movimento e do trabalho em equipe.',
    location: const LatLng(-5.0700, -42.8250),
    color: Colors.green,
    icon: Icons.fitness_center,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 3, natureza: 7, humanas: 6,
    ),
  ),
  Guild(
    id: 'computacao',
    name: 'Computação',
    description:
        'Mestres da lógica, algoritmos e sistemas tecnológicos.',
    location: const LatLng(-5.1000, -42.8350),
    color: Colors.blue,
    icon: Icons.computer,
    attributes: const GuildAttributes(
      literatura: 3, exatas: 7, natureza: 6, humanas: 2,
    ),
  ),
  Guild(
    id: 'quimica',
    name: 'Química',
    description:
        'Alquimistas que dominam as transformações da matéria.',
    location: const LatLng(-5.1200, -42.7900),
    color: Colors.teal,
    icon: Icons.biotech,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 7, natureza: 7, humanas: 2,
    ),
  ),
  Guild(
    id: 'letras',
    name: 'Letras',
    description:
        'Mestres da linguagem, literatura e comunicação.',
    location: const LatLng(-5.0550, -42.7900),
    color: Colors.pink,
    icon: Icons.menu_book,
    attributes: const GuildAttributes(
      literatura: 7, exatas: 2, natureza: 2, humanas: 7,
    ),
  ),
  Guild(
    id: 'biologia',
    name: 'Biologia',
    description:
        'Defensores da vida, biodiversidade e ecossistemas.',
    location: const LatLng(-5.1150, -42.8250),
    color: Colors.lightGreen,
    icon: Icons.eco,
    attributes: const GuildAttributes(
      literatura: 2, exatas: 4, natureza: 7, humanas: 5,
    ),
  ),
  Guild(
    id: 'direito',
    name: 'Direito',
    description:
        'Estrategistas da justiça, das leis e da diplomacia.',
    location: const LatLng(-5.0800, -42.8400),
    color: Colors.blueGrey,
    icon: Icons.gavel,
    attributes: const GuildAttributes(
      literatura: 7, exatas: 2, natureza: 2, humanas: 7,
    ),
  ),
  Guild(
    id: 'jornalismo',
    name: 'Jornalismo',
    description:
        'Mensageiros da informação, investigação e comunicação.',
    location: const LatLng(-5.0450, -42.8050),
    color: Colors.cyan,
    icon: Icons.campaign,
    attributes: const GuildAttributes(
      literatura: 7, exatas: 2, natureza: 2, humanas: 7,
    ),
  ),
  Guild(
    id: 'turismo',
    name: 'Turismo',
    description:
        'Exploradores de territórios, culturas e novas rotas.',
    location: const LatLng(-5.1250, -42.8450),
    color: Colors.deepPurple,
    icon: Icons.travel_explore,
    attributes: const GuildAttributes(
      literatura: 5, exatas: 2, natureza: 4, humanas: 7,
    ),
  ),
];
