import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';

import 'package:just_audio/just_audio.dart';

import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/cupertino.dart';

class MiniPlayer extends StatelessWidget {
  final JuzoxMusicModel song;
  final JuzoxAudioPlayerService juzoxAudioPlayerService;
  final ValueNotifier<bool> isPlaying;
  final ValueNotifier<Duration> currentDuration;
  final ValueNotifier<Duration> totalDuration;
  final ValueNotifier<ProcessingState> processingState;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.juzoxAudioPlayerService,
    required this.isPlaying,
    required this.currentDuration,
    required this.totalDuration,
    required this.processingState,
  });

  // final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  // final ValueNotifier<Duration> currentDuration = ValueNotifier(Duration.zero);
  // final ValueNotifier<Duration> totalDuration = ValueNotifier(Duration.zero);

  // @override
  // void initState() {
  //   super.initState();
  //   widget.juzoxAudioPlayerService.audioPlayer.positionStream
  //       .listen((duration) {
  //     currentDuration.value = duration;
  //   });
  //   widget.juzoxAudioPlayerService.audioPlayer.durationStream
  //       .listen((duration) {
  //     totalDuration.value = duration ?? Duration.zero;
  //   });
  //   widget.juzoxAudioPlayerService.audioPlayer.playingStream
  //       .listen((isPlaying) {
  //     this.isPlaying.value = isPlaying;
  //   });
  // }

// //dispose check once again because the miniplayer is needed for other pages also, so this dispose should be removed and use REMOVE instead(check a screenshot),,
//   @override
//   void dispose() {
//     // Dispose the ValueNotifiers when the widget is disposed
//     currentDuration.dispose();
//     totalDuration.dispose();
//     isPlaying.dispose();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    String songDisplayText =
        "${song.title!} - ${song.artist ?? 'Unknown Artist'}";

    // final double bottomNavHeight =
    //     MediaQuery.of(context).viewInsets.bottom + 56;
    // 56 is the typical height of a BottomNavigationBar

    return Container(
      //  width: 330,

      // Set width to be 90% of the screen width, for example
      // width: MediaQuery.of(context).size.width * 0.8,

      width: (MediaQuery.of(context).size.width) - 90,
      //80 is the radius of the bottom nav bar circluar edge

      // width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.only(left: bottomNavHeight, right: bottomNavHeight),

      // height: 200,
      //  color: Colors.grey[900],
      //  color: Color.fromARGB(25, 64, 195, 255),

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36)), // Rounded corners
        // border: Border.all(
        //   // Border on all sides
        //   color: Colors.grey,
        //   width: 1.0,
        // ),
        color: Color.fromARGB(255, 1, 33, 47),
      ),
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          QueryArtworkWidget(
            id: song.id!,
            type: ArtworkType.AUDIO,
            artworkHeight: 63,
            // artworkBorder: const BorderRadius.horizontal(
            //     left: Radius.circular(8), right: Radius.circular(8)),
            // artworkBorder: BorderRadius.circular(5),
            artworkBorder: const BorderRadius.only(
              topLeft: Radius.circular(36),
              //topRight: Radius.circular(8),
              //bottomLeft: Radius.circular(8),
              // bottomRight: Radius.circular(8),
            ),
            artworkClipBehavior: Clip.hardEdge,

            nullArtworkWidget: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(22, 68, 137, 255),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(8), right: Radius.circular(8))),
              // Set desired width and height for the box
              width: 50.0, // Adjust as needed
              height: 50.0, // Adjust as needed

              child: const Icon(
                Icons.music_note_outlined,
                color: Color.fromARGB(140, 64, 195, 255),
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () {},
                      constraints:
                          BoxConstraints(), // Remove constraints to minimize the size
                      padding: EdgeInsets.all(0),
                    ),
                    ValueListenableBuilder(
                        valueListenable: processingState,
                        builder: (context, state, child) {
                          return ValueListenableBuilder(
                              valueListenable: isPlaying,
                              builder: (context, isPlayingValue, child) {
                                return IconButton(
                                  icon: Icon(
                                      state == ProcessingState.completed
                                          ? Icons.play_arrow
                                          : (isPlayingValue
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                      color: Colors.white),
                                  constraints:
                                      BoxConstraints(), // Remove constraints to minimize the size
                                  padding: EdgeInsets.zero,

                                  onPressed: () {
                                    if (isPlayingValue) {
                                      juzoxAudioPlayerService.juzoxPause();
                                    } else {
                                      juzoxAudioPlayerService
                                          .juzoxPlay(song.filePath);
                                    }
                                  },
                                );
                              });
                        }),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {},
                      constraints:
                          BoxConstraints(), // Remove constraints to minimize the size
                      padding: EdgeInsets.zero,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 24,
                        child: Marquee(
                          key: ValueKey(song.filePath),
                          // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                          text: songDisplayText,
                          style: const TextStyle(
                            color: Colors.white,
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SliderTheme(
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
                      child: ValueListenableBuilder(
                          valueListenable: currentDuration,
                          builder: (context, currentDurationValue, child) {
                            return ValueListenableBuilder(
                                valueListenable: totalDuration,
                                builder: (context, totalDurationValue, child) {
                                  return Slider(
                                    activeColor:
                                        const Color.fromARGB(193, 64, 195, 255),
                                    thumbColor: Colors.lightBlueAccent,
                                    inactiveColor:
                                        const Color.fromARGB(94, 64, 195, 255),
                                    value: currentDurationValue.inSeconds
                                        .toDouble(),
                                    max:
                                        totalDurationValue.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      juzoxAudioPlayerService.audioPlayer.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                  );
                                });
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*

//code before converting to stateless

import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';

import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/cupertino.dart';

class MiniPlayer extends StatefulWidget {
  final JuzoxMusicModel song;
  final JuzoxAudioPlayerService juzoxAudioPlayerService;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.juzoxAudioPlayerService,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  final ValueNotifier<Duration> currentDuration = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> totalDuration = ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    widget.juzoxAudioPlayerService.audioPlayer.positionStream
        .listen((duration) {
      currentDuration.value = duration;
    });
    widget.juzoxAudioPlayerService.audioPlayer.durationStream
        .listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
    widget.juzoxAudioPlayerService.audioPlayer.playingStream
        .listen((isPlaying) {
      this.isPlaying.value = isPlaying;
    });
  }

//dispose check once again because the miniplayer is needed for other pages also, so this dispose should be removed and use REMOVE instead(check a screenshot),,
  @override
  void dispose() {
    // Dispose the ValueNotifiers when the widget is disposed
    currentDuration.dispose();
    totalDuration.dispose();
    isPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String songDisplayText =
        "${widget.song.title!} - ${widget.song.artist ?? 'Unknown Artist'}";

    // final double bottomNavHeight =
    //     MediaQuery.of(context).viewInsets.bottom + 56;
    // 56 is the typical height of a BottomNavigationBar

    return Container(
      //  width: 330,

      // Set width to be 90% of the screen width, for example
      // width: MediaQuery.of(context).size.width * 0.8,

      width: (MediaQuery.of(context).size.width) - 90,
      //80 is the radius of the bottom nav bar circluar edge

      // width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.only(left: bottomNavHeight, right: bottomNavHeight),

      // height: 200,
      //  color: Colors.grey[900],
      //  color: Color.fromARGB(25, 64, 195, 255),

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36)), // Rounded corners
        // border: Border.all(
        //   // Border on all sides
        //   color: Colors.grey,
        //   width: 1.0,
        // ),
        color: Color.fromARGB(255, 1, 33, 47),
      ),
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          QueryArtworkWidget(
            id: widget.song.id!,
            type: ArtworkType.AUDIO,
            artworkHeight: 63,
            // artworkBorder: const BorderRadius.horizontal(
            //     left: Radius.circular(8), right: Radius.circular(8)),
            // artworkBorder: BorderRadius.circular(5),
            artworkBorder: const BorderRadius.only(
              topLeft: Radius.circular(36),
              //topRight: Radius.circular(8),
              //bottomLeft: Radius.circular(8),
              // bottomRight: Radius.circular(8),
            ),
            artworkClipBehavior: Clip.hardEdge,

            nullArtworkWidget: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(22, 68, 137, 255),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(8), right: Radius.circular(8))),
              // Set desired width and height for the box
              width: 50.0, // Adjust as needed
              height: 50.0, // Adjust as needed

              child: const Icon(
                Icons.music_note_outlined,
                color: Color.fromARGB(140, 64, 195, 255),
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () {},
                      constraints:
                          BoxConstraints(), // Remove constraints to minimize the size
                      padding: EdgeInsets.all(0),
                    ),
                    ValueListenableBuilder(
                        valueListenable: isPlaying,
                        builder: (context, isPlaying, child) {
                          return IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white),
                            constraints:
                                BoxConstraints(), // Remove constraints to minimize the size
                            padding: EdgeInsets.zero,

                            onPressed: () {
                              if (isPlaying) {
                                widget.juzoxAudioPlayerService.juzoxPause();
                              } else {
                                widget.juzoxAudioPlayerService
                                    .juzoxPlay(widget.song.filePath);
                              }
                            },
                          );
                        }),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {},
                      constraints:
                          BoxConstraints(), // Remove constraints to minimize the size
                      padding: EdgeInsets.zero,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 24,
                        child: Marquee(
                          key: ValueKey(widget.song.filePath),
                          // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                          text: songDisplayText,
                          style: const TextStyle(
                            color: Colors.white,
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SliderTheme(
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
                      child: ValueListenableBuilder(
                          valueListenable: currentDuration,
                          builder: (context, currentDurationValue, child) {
                            return ValueListenableBuilder(
                                valueListenable: totalDuration,
                                builder: (context, totalDurationValue, child) {
                                  return Slider(
                                    activeColor:
                                        const Color.fromARGB(193, 64, 195, 255),
                                    thumbColor: Colors.lightBlueAccent,
                                    inactiveColor:
                                        const Color.fromARGB(94, 64, 195, 255),
                                    value: currentDurationValue.inSeconds
                                        .toDouble(),
                                    max:
                                        totalDurationValue.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      widget.juzoxAudioPlayerService.audioPlayer
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    },
                                  );
                                });
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


*/