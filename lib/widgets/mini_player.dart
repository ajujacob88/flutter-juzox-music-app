import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/screens/main_player.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';

import 'package:just_audio/just_audio.dart';

import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final JuzoxMusicModel song;

  const MiniPlayer({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    String songDisplayText =
        "${song.title!} - ${song.artist ?? 'Unknown Artist'}";

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => MainPlayer(),
        // ));

        Navigator.of(context).push(_createRoute());
      },
      child: Container(
        //  width: 330,

        // Set width to be 90% of the screen width, for example
        // width: MediaQuery.of(context).size.width * 0.8,

        width: (MediaQuery.of(context).size.width) - 90,
        //80 is the radius of the bottom nav bar circluar edge

        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36)), // Rounded corners

          color: Color.fromARGB(255, 1, 33, 47),
        ),
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: [
            QueryArtworkWidget(
              id: song.id!,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          onPressed: () {
                            Provider.of<AudioPlayerProvider>(context,
                                    listen: false)
                                .playPreviousSong();
                          },
                          // constraints:
                          //     BoxConstraints(), // Remove constraints to minimize the size
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                      Selector<AudioPlayerProvider, IconData>(
                        selector: (context, provider) {
                          if (provider.processingState ==
                              ProcessingState.completed) {
                            return Icons.play_arrow;
                          } else {
                            return provider.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow;
                          }
                        },
                        shouldRebuild: (previous, current) =>
                            previous != current,
                        builder: (context, iconData, child) {
                          return Expanded(
                            child: IconButton(
                              icon: Icon(
                                iconData,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                final audioPlayerService = context
                                    .read<AudioPlayerProvider>()
                                    .juzoxAudioPlayerService;
                                //  if(context.read<AudioPlayerProvider>().isPlaying)
                                if (audioPlayerService.audioPlayer.playing) {
                                  audioPlayerService.juzoxPause();
                                } else {
                                  audioPlayerService.juzoxPlay(song.filePath);
                                }
                              },
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: IconButton(
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: () {
                            Provider.of<AudioPlayerProvider>(context,
                                    listen: false)
                                .playNextSong();
                          },
                          // constraints:
                          //     BoxConstraints(), // Remove constraints to minimize the size
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        flex: 4,
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
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 22.0),
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
                          shouldRebuild: (previous, current) =>
                              previous != current,
                          builder: (context, sliderValue, child) {
                            // final maxDuration = context
                            //     .read<AudioPlayerProvider>()
                            //     .totalDuration
                            //     .inSeconds
                            //     .toDouble();
                            return Slider(
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
// for page route animation
//Method 1
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MainPlayer(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
*/

/*
// for page route animation
//Method 2
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MainPlayer(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
*/

/*
// for page route animation
//Method 3
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MainPlayer(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
*/

//my experiments

Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    reverseTransitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => const MainPlayer(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<double>(begin: 0.0, end: 1.0);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.ease,
      );

      return FadeTransition(
        opacity: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
