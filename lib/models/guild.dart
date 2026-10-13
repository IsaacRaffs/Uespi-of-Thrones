import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Guild {
  final String id;
  final String name;

  final LatLng location;
  final Color color;

  int coins;
  int books;
  int bookshelves;
  int shoes;

  int health;

  Guild({
    required this.id,
    required this.name,
    required this.location,
    required this.color,
    this.coins = 0,
    this.books = 0,
    this.bookshelves = 0,
    this.shoes = 0,
    this.health = 1000,
  });

  bool get isAlive => health > 0;
}