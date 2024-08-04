import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayerService({required this.currentUrl});

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPaused = false;
  final String currentUrl;

  // Play method
  Future<void> play() async {
    try {
      await _audioPlayer.play(AssetSource(currentUrl));
    } catch (e) {
      throw AudioPlayerException('Error playing audio: $e');
    }
  }

  // Stop method
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPaused = false;
    } catch (e) {
      throw AudioPlayerException('Error stopping audio: $e');
    }
  }

  // Resume method
  Future<void> resume() async {
    if (_isPaused) {
      try {
        await _audioPlayer.resume();
      } catch (e) {
        throw AudioPlayerException('Error resuming audio: $e');
      }
    } else {
      throw AudioPlayerException('No audio to resume or audio not paused');
    }
  }

  // Pause method
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw AudioPlayerException('Error pausing audio: $e');
    }
  }
}

class AudioPlayerException implements Exception {
  final String message;
  AudioPlayerException(this.message);

  @override
  String toString() => 'AudioPlayerException: $message';
}
