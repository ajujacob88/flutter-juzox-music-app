import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:marquee/marquee.dart';
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
        title: const Text('Playing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Selector<AudioPlayerProvider, JuzoxMusicModel?>(
          selector: (context, audioPlayerProvider) =>
              audioPlayerProvider.currentlyPlayingSong,
          shouldRebuild: (previous, current) => previous != current,
          builder: (context, currentlyPlayingSong, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 20),
                // SizedBox(
                // height: 300,
                // width: 300,

                const Spacer(
                  flex: 1,
                ),

                QueryArtworkWidget(
                  id: currentlyPlayingSong!.id!,
                  type: ArtworkType.AUDIO,
                  size: 500,
                  quality: 100,
                  artworkHeight: 300,
                  artworkWidth: 300,

                  artworkBorder: const BorderRadius.all(
                    Radius.circular(12),
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
                ),
                //  ),

                //  const SizedBox(height: 20),
                const Spacer(
                  flex: 2,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Spacer(
                    //   flex: 1,
                    // ),
                    const SizedBox(
                      width: 23,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 50,
                            // width: 250,
                            child: Marquee(
                              key: ValueKey(currentlyPlayingSong!.filePath),
                              // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                              text: currentlyPlayingSong.title ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                              //textScaleFactor: 1.3,
                              // blankSpace: 40.0,
                              // velocity: 30,

                              blankSpace: 40.0,
                              velocity: 20,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                            ),
                          ),

                          // // const SizedBox(height: 20),

                          SizedBox(
                            height: 26,
                            //  width: 330,
                            child: Marquee(
                              key: ValueKey(currentlyPlayingSong.filePath),
                              // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                              text:
                                  "${currentlyPlayingSong.album ?? 'Unknown Album'} - ${currentlyPlayingSong.artist ?? 'Unknown Artist'} ",
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 16,
                              ),
                              //textScaleFactor: 1.3,
                              // blankSpace: 40.0,
                              // velocity: 30,

                              blankSpace: 40.0,
                              velocity: 20,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      //fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border),
                            color: const Color.fromARGB(156, 64, 195, 255),
                          ),
                          Transform.rotate(
                            angle: 1.5708, // Convert degrees to radians
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.tune_outlined),
                              color: const Color.fromARGB(156, 64, 195, 255),
                              //iconSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(
                  flex: 2,
                ),

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
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 22.0),
                    tickMarkShape: const RoundSliderTickMarkShape(),
                    //     activeTickMarkColor: Colors.pinkAccent,
                    //   inactiveTickMarkColor: Colors.white,
                    valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
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

                      final maxDuration =
                          provider.totalDuration.inSeconds.toDouble();
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
                      return Column(
                        children: [
                          Slider(
                            activeColor:
                                const Color.fromARGB(193, 64, 195, 255),
                            thumbColor: Colors.lightBlueAccent,
                            inactiveColor:
                                const Color.fromARGB(94, 64, 195, 255),
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
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatDuration(sliderValue)),

                                Text(formatDuration(context
                                    .read<AudioPlayerProvider>()
                                    .totalDuration
                                    .inSeconds
                                    .toDouble())),

                                //using the formatDuration function that i created is more efficient, because it is arithematic operation,, below one is string manipulation which is less performant compared to arithematic operation

                                // Text('${context.read<AudioPlayerProvider>().currentDuration.toString().substring(2, 7)}'),
                                // Text('${context.read<AudioPlayerProvider>().totalDuration.toString().substring(2, 7)}'),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),

                //SizedBox(height: 20),
                // Control Buttons

                // const Spacer(
                //     //flex: 1,
                //     ),
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
                        if (audioPlayerProvider.isPlaying) {
                          audioPlayerProvider.juzoxAudioPlayerService
                              .juzoxPause();
                        } else {
                          audioPlayerProvider.juzoxAudioPlayerService
                              .juzoxPlay(currentlyPlayingSong.filePath);
                        }
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
                const Spacer(
                  flex: 2,
                ),
              ],
            );
          }),
    );
  }
}

String formatDuration(double durationInSeconds) {
  int minutes = (durationInSeconds / 60).floor();
  int seconds = (durationInSeconds % 60).floor();
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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