import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

class RosarioAudioService {
  RosarioAudioService._();

  static final RosarioAudioService instance = RosarioAudioService._();

  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  bool _initialized = false;
  bool _isPlaying = false;

  String? _currentTipo;
  String? _currentAsset;
  int? _lastVariant;

  bool get isPlaying => _isPlaying;
  String? get currentAsset => _currentAsset;
  String? get currentTipo => _currentTipo;

  Future<void> init() async {
    if (_initialized) return;

    await _player.setReleaseMode(ReleaseMode.loop);

    await _player.setAudioContext(
      AudioContextConfig(
        route: AudioContextConfigRoute.speaker,
        focus: AudioContextConfigFocus.gain,
        respectSilence: false,
        stayAwake: false,
      ).build(),
    );

    await _player.setVolume(0.22);

    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
    });

    _initialized = true;
  }

  Future<void> playAmbientForMysteryType(
    String tipo, {
    double volume = 0.22,
    bool forceNewVariant = false,
  }) async {
    await init();

    final normalized = _normalizeTipo(tipo);
    final variant = _pickVariant(forceNewVariant: forceNewVariant);
    final asset = _buildAssetPath(normalized, variant);

    final shouldReload =
        forceNewVariant || _currentAsset != asset || _currentTipo != normalized;

    await _player.setVolume(volume.clamp(0.0, 1.0));

    if (shouldReload) {
      await _player.stop();

      await _player.play(
        AssetSource(asset),
        volume: volume.clamp(0.0, 1.0),
      );

      _currentTipo = normalized;
      _currentAsset = asset;
      _lastVariant = variant;
      _isPlaying = true;
      return;
    }

    if (!_isPlaying) {
      await _player.resume();
      _isPlaying = true;
    }
  }

  Future<void> switchMysteryType(
    String tipo, {
    double volume = 0.22,
  }) async {
    final normalized = _normalizeTipo(tipo);

    if (_currentTipo == normalized && _isPlaying) return;

    await playAmbientForMysteryType(
      normalized,
      volume: volume,
      forceNewVariant: true,
    );
  }

  Future<void> nextVariant({
    double volume = 0.22,
  }) async {
    if (_currentTipo == null) return;

    await playAmbientForMysteryType(
      _currentTipo!,
      volume: volume,
      forceNewVariant: true,
    );
  }

  Future<void> pauseAmbient() async {
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> resumeAmbient() async {
    await _player.resume();
    _isPlaying = true;
  }

  Future<void> stopAmbient() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> setVolume(double value) async {
    final safe = value.clamp(0.0, 1.0);
    await _player.setVolume(safe);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  String _normalizeTipo(String tipo) {
    switch (tipo.trim().toLowerCase()) {
      case 'gozosos':
        return 'gozosos';
      case 'dolorosos':
        return 'dolorosos';
      case 'gloriosos':
        return 'gloriosos';
      case 'luminosos':
        return 'luminosos';
      default:
        return 'gozosos';
    }
  }

  int _pickVariant({bool forceNewVariant = false}) {
    if (!forceNewVariant && _lastVariant != null) {
      return _lastVariant!;
    }

    final variants = [1, 2, 3];

    if (_lastVariant != null) {
      variants.remove(_lastVariant);
    }

    return variants[_random.nextInt(variants.length)];
  }

  String _buildAssetPath(String tipo, int variant) {
    return '$tipo/rosario_${tipo}_$variant.mp3';
  }
}
