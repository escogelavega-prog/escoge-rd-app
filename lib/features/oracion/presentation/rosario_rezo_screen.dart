import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

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

    await _player.setVolume(0.0);

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      debugPrint('🎧 PlayerState: $state');
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

    final safeVolume = volume.clamp(0.0, 1.0);

    debugPrint('🎧 Intentando reproducir: $asset');

    if (!shouldReload) {
      if (!_isPlaying) {
        await _player.resume();
        await _fadeVolume(
          from: 0.0,
          to: safeVolume,
          duration: const Duration(milliseconds: 900),
        );
      }
      return;
    }

    if (_currentAsset != null) {
      await _fadeOutAndStop();
    } else {
      await _player.stop();
    }

    await _player.setVolume(0.0);

    await _player.play(
      AssetSource(asset),
      volume: 0.0,
    );

    _currentTipo = normalized;
    _currentAsset = asset;
    _lastVariant = variant;

    await _fadeVolume(
      from: 0.0,
      to: safeVolume,
      duration: const Duration(milliseconds: 1200),
    );
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
    await _fadeOutAndPause();
  }

  Future<void> resumeAmbient({double volume = 0.22}) async {
    if (_currentAsset == null) return;

    await _player.resume();
    await _fadeVolume(
      from: 0.0,
      to: volume.clamp(0.0, 1.0),
      duration: const Duration(milliseconds: 900),
    );
  }

  Future<void> stopAmbient() async {
    await _fadeOutAndStop();
  }

  Future<void> setVolume(double value) async {
    final safe = value.clamp(0.0, 1.0);
    await _player.setVolume(safe);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<void> _fadeOutAndPause() async {
    await _fadeVolume(
      from: 0.22,
      to: 0.0,
      duration: const Duration(milliseconds: 700),
    );
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> _fadeOutAndStop() async {
    await _fadeVolume(
      from: 0.22,
      to: 0.0,
      duration: const Duration(milliseconds: 700),
    );
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> _fadeVolume({
    required double from,
    required double to,
    Duration duration = const Duration(milliseconds: 900),
  }) async {
    const steps = 12;
    final stepDuration = duration.inMilliseconds ~/ steps;

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final value = from + ((to - from) * t);
      await _player.setVolume(value.clamp(0.0, 1.0));
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
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

    if (_lastVariant != null && variants.length > 1) {
      variants.remove(_lastVariant);
    }

    return variants[_random.nextInt(variants.length)];
  }

  String _buildAssetPath(String tipo, int variant) {
    return 'audio/$tipo/rosario_${tipo}_$variant.mp3';
  }
}
