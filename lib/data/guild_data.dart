import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/guild.dart';

final List<Guild> guilds = [
  Guild(
    id: 'guild_1',
    name: 'Dragões do Pirajá',
    location: const LatLng(-5.0892, -42.8016),
    color: Colors.red,
  ),

  Guild(
    id: 'guild_2',
    name: 'Lobos de Teresina',
    location: const LatLng(-5.0755, -42.7890),
    color: Colors.blue,
  ),

  Guild(
    id: 'guild_3',
    name: 'Guardiões do Poti',
    location: const LatLng(-5.1020, -42.8150),
    color: Colors.green,
  ),

  Guild(
    id: 'guild_4',
    name: 'Corvos do Norte',
    location: const LatLng(-5.0600, -42.8100),
    color: Colors.purple,
  ),
];