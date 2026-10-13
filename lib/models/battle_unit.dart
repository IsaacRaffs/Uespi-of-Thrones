import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BattleUnit {
  final String id;

  final String attackerGuildId;
  final String targetGuildId;

  final LatLng start;
  final LatLng destination;

  final Color color;

  double progress;

  BattleUnit({
    required this.id,
    required this.attackerGuildId,
    required this.targetGuildId,
    required this.start,
    required this.destination,
    required this.color,
    this.progress = 0,
  });

  LatLng get currentPosition {
    final latitude =
        start.latitude +
        (destination.latitude - start.latitude) * progress;

    final longitude =
        start.longitude +
        (destination.longitude - start.longitude) * progress;

    return LatLng(latitude, longitude);
  }

  bool get arrived => progress >= 1;
}