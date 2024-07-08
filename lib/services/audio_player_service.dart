import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';

class JuzoxAudioPlayerService {
  JuzoxAudioPlayerService(this.flutterLocalNotificationsPlugin);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final _audioPlayer = AudioPlayer(); // Create a player

  String? _currentUrl;

  AudioPlayer get audioPlayer => _audioPlayer;
  //The line AudioPlayer get audioPlayer => _audioPlayer; is a getter in Dart that provides access to the private _audioPlayer instance from outside the AudioPlayerService class.

  Future<void> juzoxPlay(String url) async {
    // await _audioPlayer.setUrl(url);
    // _audioPlayer.play();

    // By using the below approach using current url check, you avoid unnecessary loading of the same song when the play button is pressed after a pause. This way, if the same song is already loaded, it just resumes from where it was paused instead of restarting it.
    showNotification('aju1', 'aju2');
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

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'music_player_channel', // Replace with a unique channel ID
      'Music Player', // Replace with a channel name
      channelDescription:
          'Your channel description', // Replace with a channel description
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: MediaStyleInformation(),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
    );
  }
}
