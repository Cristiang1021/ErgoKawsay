import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/models/music_track.dart';

/// Global singleton audio controller. Persists for app lifetime.
class AudioController extends ChangeNotifier {
  static final AudioController instance = AudioController._();

  AudioController._() {
    _player.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });
    _player.durationStream.listen((d) {
      if (d != null) {
        _duration = d;
        notifyListeners();
      }
    });
    _player.playerStateStream.listen((s) {
      _isPlaying = s.playing;
      if (s.processingState == ProcessingState.completed) {
        _onTrackCompleted();
      }
      notifyListeners();
    });
  }

  final AudioPlayer _player = AudioPlayer();

  MusicTrack? _currentTrack;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _error;

  List<MusicTrack> _playlist = [];
  int _currentIndex = -1;

  MusicTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get error => _error;
  bool get hasActiveTrack => _currentTrack != null;
  bool get hasPrevious => _currentIndex > 0;
  bool get hasNext =>
      _playlist.isNotEmpty && _currentIndex < _playlist.length - 1;

  double get progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  Future<void> playTrack(MusicTrack track, {List<MusicTrack>? playlist}) async {
    if (playlist != null) _playlist = List.unmodifiable(playlist);
    final idx = _playlist.indexWhere((t) => t.id == track.id);
    if (idx >= 0) _currentIndex = idx;

    _error = null;
    _currentTrack = track;
    notifyListeners();
    try {
      await _player.stop();
      if (track.isAsset) {
        await _player.setAsset(track.assetPath);
      } else if (track.url != null) {
        await _player.setUrl(track.url!);
      }
      await _player.play();
    } catch (_) {
      _error = 'Audio no disponible';
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> previous() async {
    if (!hasPrevious) return;
    await playTrack(_playlist[_currentIndex - 1]);
  }

  Future<void> next() async {
    if (!hasNext) return;
    await playTrack(_playlist[_currentIndex + 1]);
  }

  Future<void> stop() async {
    await _player.stop();
    _currentTrack = null;
    _currentIndex = -1;
    _position = Duration.zero;
    _duration = Duration.zero;
    _error = null;
    notifyListeners();
  }

  void seek(Duration position) => _player.seek(position);

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onTrackCompleted() {
    if (hasNext) {
      playTrack(_playlist[_currentIndex + 1]);
    }
  }
}
