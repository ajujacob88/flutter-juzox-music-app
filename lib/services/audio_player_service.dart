import 'package:just_audio/just_audio.dart';

class JuzoxAudioPlayerService {
  final _audioPlayer = AudioPlayer(); // Create a player

  AudioPlayer get audioPlayer => _audioPlayer;
  //The line AudioPlayer get audioPlayer => _audioPlayer; is a getter in Dart that provides access to the private _audioPlayer instance from outside the AudioPlayerService class.

  Future<void> juzoxPlay(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  Future<void> juzoxPause() async {
    _audioPlayer.pause();
  }

  Future<void> juzoxStop() async {
    _audioPlayer.stop();
  }

  bool juzoxPlaying() {
    return _audioPlayer.playing;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
