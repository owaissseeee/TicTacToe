import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  Future<void> init() async {
    await AudioPlayer.global.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );
  }

  Future<void> playBGM() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

    if (_isMuted) return;

    try {
      await _bgmPlayer.play(AssetSource('sound/theme.mp3'), volume: 0.4);
    } catch (e) {
      print("Error playing BGM: $e");
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;

    if (_isMuted) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.resume();

      if (_bgmPlayer.state != PlayerState.playing) {
        playBGM();
      }
    }
  }

  Future<void> playClick() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sound/click.mp3'), volume: 1.0);
  }

  Future<void> playError() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sound/error.mp3'), volume: 1.0);
  }

  Future<void> playWin() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sound/win.mp3'), volume: 1.0);
  }
}
