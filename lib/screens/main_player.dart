import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/widgets/mini_player.dart';
import 'package:provider/provider.dart';

class MainPlayer extends StatelessWidget {
  const MainPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentlyPlayingSong?.title ?? 'No song playing'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentlyPlayingSong?.title ?? 'No song playing'),
          Text(currentlyPlayingSong?.artist ?? 'Unknown Artist'),
          IconButton(
            icon: Icon(
                audioPlayerProvider.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              //  audioPlayerProvider.togglePlayPause();
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: () {
              audioPlayerProvider.playPreviousSong();
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              audioPlayerProvider.playNextSong();
            },
          ),
        ],
      ),
    );
  }
}
