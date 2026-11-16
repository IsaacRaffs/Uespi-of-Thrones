import 'package:audioplayers/audioplayers.dart';

/// Centraliza as músicas de fundo e os efeitos sonoros do jogo.
///
/// Use uma única instância: AudioService.instance.
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer();

  String? _currentMusic;
  bool _musicEnabled = true;
  bool _effectsEnabled = true;
  double _musicVolume = 0.45;
  double _effectsVolume = 0.75;

  bool get musicEnabled => _musicEnabled;
  bool get effectsEnabled => _effectsEnabled;

  Future<void>? _initialization;

  Future<void> initialize() {
    // Garante que os players sejam configurados uma única vez, mesmo se
    // menu, jogo e batalha solicitarem áudio quase simultaneamente.
    return _initialization ??= _configurePlayers();
  }

  Future<void> _configurePlayers() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);
    await _effectsPlayer.setReleaseMode(ReleaseMode.stop);
    await _effectsPlayer.setVolume(_effectsVolume);
  }

  Future<void> _playMusic(String asset) async {
    await initialize();
    if (!_musicEnabled) return;
    if (_currentMusic == asset && _musicPlayer.state == PlayerState.playing) {
      return;
    }

    _currentMusic = asset;
    await _musicPlayer.stop();
    await _musicPlayer.play(AssetSource('audio/$asset'));
  }

  Future<void> playMenuMusic() => _playMusic('menu_music.mp3');

  Future<void> playExplorationMusic() => _playMusic('exploration_music.mp3');

  Future<void> playBattleMusic() => _playMusic('battle_music.mp3');

  Future<void> playClick() => _playEffect('button_click.mp3');

  Future<void> playXpReward() => _playEffect('xp_reward.wav');

  Future<void> _playEffect(String asset) async {
    await initialize();
    if (!_effectsEnabled) return;

    // O player de efeitos é separado do player musical.
    // Assim, o efeito não interrompe a música de fundo.
    await _effectsPlayer.stop();
    await _effectsPlayer.play(
      AssetSource('audio/$asset'),
      volume: _effectsVolume,
    );
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    if (!enabled) {
      await _musicPlayer.pause();
    } else if (_currentMusic != null) {
      await _musicPlayer.resume();
    }
  }

  Future<void> setEffectsEnabled(bool enabled) async {
    _effectsEnabled = enabled;
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume);
  }

  Future<void> setEffectsVolume(double volume) async {
    _effectsVolume = volume.clamp(0.0, 1.0);
    await _effectsPlayer.setVolume(_effectsVolume);
  }

  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _effectsPlayer.dispose();
  }
}
