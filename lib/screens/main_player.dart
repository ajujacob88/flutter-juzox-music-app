import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {},
        ),
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
          // Song Image
          QueryArtworkWidget(
            id: currentlyPlayingSong!.id!,
            type: ArtworkType.AUDIO,
            // artworkHeight: 63,
            artworkHeight: 65,

            artworkBorder: const BorderRadius.only(
              topLeft: Radius.circular(36),
            ),
            artworkClipBehavior: Clip.hardEdge,

            nullArtworkWidget: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(22, 68, 137, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                ),
              ),
              // Set desired width and height for the box
              width: 50.0, // Adjust as needed
              // height: 63.0, // Adjust as needed
              height: 65.0,
              child: const Icon(
                Icons.music_note_outlined,
                color: Color.fromARGB(140, 64, 195, 255),
                size: 30,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Seek Bar
          Slider(
            value: audioPlayerProvider.currentDuration.inSeconds.toDouble(),
            max: audioPlayerProvider.totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              final position = Duration(seconds: value.toInt());
              audioPlayerProvider.juzoxAudioPlayerService.audioPlayer
                  .seek(position);
            },
          ),
          // Song Details
          Text(currentlyPlayingSong?.title ?? 'No song playing'),
          Text(currentlyPlayingSong?.artist ?? 'Unknown Artist'),
          SizedBox(height: 20),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  audioPlayerProvider.playPreviousSong();
                },
              ),
              IconButton(
                icon: Icon(audioPlayerProvider.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  // audioPlayerProvider.togglePlayPause();
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
        ],
      ),
    );
  }
}

/*
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
*/