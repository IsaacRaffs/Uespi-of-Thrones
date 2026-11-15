import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class GuildAttributes {
  final int literatura;
  final int exatas;
  final int natureza;
  final int humanas;

  const GuildAttributes({
    required this.literatura,
    required this.exatas,
    required this.natureza,
    required this.humanas,
  }) : assert(literatura >= 0 && literatura <= 100),
       assert(exatas >= 0 && exatas <= 100),
       assert(natureza >= 0 && natureza <= 100),
       assert(humanas >= 0 && humanas <= 100);
}

class Guild {
  final String id;
  final String name;
  final String description;
  final LatLng location;
  final Color color;
  final IconData icon;
  final GuildAttributes attributes;

  int coins;
  int books;
  int health;

  Guild({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.color,
    required this.icon,
    required this.attributes,
    this.coins = 0,
    this.books = 0,
    this.health = 1000,
  });

  bool get isAlive => health > 0;
}
