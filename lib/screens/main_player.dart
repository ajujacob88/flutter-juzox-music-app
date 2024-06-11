import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainPlayer extends StatelessWidget {
  const MainPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    // final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Selector<AudioPlayerProvider, JuzoxMusicModel?>(
            selector: (context, audioPlayerProvider) =>
                audioPlayerProvider.currentlyPlayingSong,
            builder: (context, currentlyPlayingSong, _) {
              return Text(currentlyPlayingSong?.title ?? 'No song playing');
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
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
          Selector<AudioPlayerProvider, JuzoxMusicModel?>(
              selector: (context, audioPlayerProvider) =>
                  audioPlayerProvider.currentlyPlayingSong,
              builder: (context, currentlyPlayingSong, _) {
                return QueryArtworkWidget(
                  id: currentlyPlayingSong!.id!,
                  type: ArtworkType.AUDIO,
                  //size: 165,
                  quality: 100,
                  artworkHeight: 300,
                  artworkWidth: 300,

                  artworkBorder: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                  ),
                  //  artworkClipBehavior: Clip.hardEdge,

                  artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                  artworkFit: BoxFit.cover,
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
                );
              }),
          const SizedBox(height: 20),
          // Seek Bar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0.8,
              trackShape: const RoundedRectSliderTrackShape(),
              //  activeTrackColor: Colors.purple.shade800,
              //  inactiveTrackColor: Colors.purple.shade100,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8.0,
                pressedElevation: 20.0,
              ),
              //     thumbColor: Colors.pinkAccent,
              //     overlayColor: Colors.pink.withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 22.0),
              tickMarkShape: const RoundSliderTickMarkShape(),
              //     activeTickMarkColor: Colors.pinkAccent,
              //   inactiveTickMarkColor: Colors.white,
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.black,
              // valueIndicatorTextStyle: const TextStyle(
              //   color: Colors.white,
              //   fontSize: 20.0,
              // ),
            ),
            child: Selector<AudioPlayerProvider, double>(
              selector: (context, provider) {
                final currentDuration =
                    provider.currentDuration.inSeconds.toDouble();
                final maxDuration = provider.totalDuration.inSeconds.toDouble();
                return currentDuration > maxDuration
                    ? maxDuration
                    : currentDuration;
              },
              shouldRebuild: (previous, current) => previous != current,
              builder: (context, sliderValue, child) {
                // final maxDuration = context
                //     .read<AudioPlayerProvider>()
                //     .totalDuration
                //     .inSeconds
                //     .toDouble();
                return Slider(
                  activeColor: const Color.fromARGB(193, 64, 195, 255),
                  thumbColor: Colors.lightBlueAccent,
                  inactiveColor: const Color.fromARGB(94, 64, 195, 255),
                  value: sliderValue,
                  max: context
                      .read<AudioPlayerProvider>()
                      .totalDuration
                      .inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    context
                        .read<AudioPlayerProvider>()
                        .juzoxAudioPlayerService
                        .audioPlayer
                        .seek(Duration(seconds: value.toInt()));
                  },
                );
              },
            ),
          ),
          // Song Details
          Selector<AudioPlayerProvider, JuzoxMusicModel?>(
              selector: (context, audioPlayerProvider) =>
                  audioPlayerProvider.currentlyPlayingSong,
              builder: (context, currentlyPlayingSong, _) {
                return Text(currentlyPlayingSong?.title ?? 'No song playing');
              }),
          Selector<AudioPlayerProvider, JuzoxMusicModel?>(
              selector: (context, audioPlayerProvider) =>
                  audioPlayerProvider.currentlyPlayingSong,
              builder: (context, currentlyPlayingSong, _) {
                return Text(currentlyPlayingSong?.artist ?? 'Unknown Artist');
              }),
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