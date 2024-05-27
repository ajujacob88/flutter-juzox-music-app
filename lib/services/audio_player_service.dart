import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final _audioPlayer = AudioPlayer(); // Create a player

  AudioPlayer get audioPlayer => _audioPlayer;
  //The line AudioPlayer get audioPlayer => _audioPlayer; is a getter in Dart that provides access to the private _audioPlayer instance from outside the AudioPlayerService class.

  Future<void> play(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  Future<void> pause() async {
    _audioPlayer.pause();
  }

  Future<void> stop() async {
    _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
