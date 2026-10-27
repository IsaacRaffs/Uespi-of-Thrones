
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_save.dart';

class SaveService {
  static final SaveService instance = SaveService._();

  SaveService._();

  final SharedPreferencesAsync _prefs =
      SharedPreferencesAsync();

  String _key(int slot) => 'uespi_save_$slot';

  void _validateSlot(int slot) {
    if (slot < 1 || slot > 3) {
      throw ArgumentError('O slot deve ser de 1 a 3.');
    }
  }

  Future<GameSave?> load(int slot) async {
    _validateSlot(slot);

    final raw = await _prefs.getString(_key(slot));
    if (raw == null) return null;

    try {
      return GameSave.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      throw FormatException(
        'Save $slot está corrompido.',
      );
    }
  }

  Future<List<GameSave?>> loadAll() async {
    return Future.wait([
      load(1),
      load(2),
      load(3),
    ]);
  }

  Future<void> save(GameSave game) async {
    _validateSlot(game.slot);

    await _prefs.setString(
      _key(game.slot),
      jsonEncode(game.toJson()),
    );
  }

  Future<GameSave> create(
    int slot,
    String guildId,
  ) async {
    _validateSlot(slot);

    if (await load(slot) != null) {
      throw StateError('Este slot já está ocupado.');
    }

    final now = DateTime.now();

    final game = GameSave(
      slot: slot,
      guildId: guildId,
      createdAt: now,
      updatedAt: now,
    );

    await save(game);
    return game;
  }

  Future<void> delete(int slot) async {
    _validateSlot(slot);
    await _prefs.remove(_key(slot));
  }
}
