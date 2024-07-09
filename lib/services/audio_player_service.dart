import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class JuzoxAudioPlayerService {
  final _audioPlayer = AudioPlayer(); // Create a player

  String? _currentUrl;

  AudioPlayer get audioPlayer => _audioPlayer;
  //The line AudioPlayer get audioPlayer => _audioPlayer; is a getter in Dart that provides access to the private _audioPlayer instance from outside the AudioPlayerService class.

  //for notification and background playback
  Future<void> playForNotification(String filePath, String id, String title,
      String artist, String album, String artUri) async {
    await _audioPlayer.setAudioSource(AudioSource.file(filePath,
            tag: MediaItem(
              id: id,
              title: title,
              album: album,
              artist: artist,
            ))
        // AudioSource.uri(
        //   Uri.parse(url),
        //   tag: MediaItem(
        //     id: url,
        //      album: album,
        //    title: title,
        //    artist: artist,
        //         artUri: Uri.parse(artUri),
        //   ),
        // ),
        );
    _audioPlayer.play();
  }

  Future<void> juzoxPlay(String url) async {
    // await _audioPlayer.setUrl(url);
    // _audioPlayer.play();

    // By using the below approach using current url check, you avoid unnecessary loading of the same song when the play button is pressed after a pause. This way, if the same song is already loaded, it just resumes from where it was paused instead of restarting it.
    if (_currentUrl != url) {
      _currentUrl = url;
      await _audioPlayer.setUrl(url);
    }
    _audioPlayer.play();
  }

  Future<void> juzoxPause() async {
    _audioPlayer.pause();
  }

  Future<void> juzoxStop() async {
    _audioPlayer.stop();
  }

  // bool juzoxPlaying() {
  //   return _audioPlayer.playing;
  // }

  void dispose() {
    _audioPlayer.dispose();
  }
}
