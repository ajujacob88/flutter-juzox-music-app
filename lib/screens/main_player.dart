import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/utils/format_duration.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainPlayer extends StatefulWidget {
  const MainPlayer({super.key});

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> with TickerProviderStateMixin {
  late AnimationController _alignAnimationController;
  late final Animation<AlignmentGeometry> _alignAnimation;

  double opacityLevel = 0.5;
  // late final AnimationController _controller2 = AnimationController(
  //   duration: const Duration(seconds: 5),
  //   vsync: this,
  // )..repeat(reverse: true);
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller2,
  //   curve: Curves.easeIn,
  // );

  late AnimationController _fadeAnimationController;
  late final Animation<double> _fadeAnimation;

  // late final AnimationController _fadeAnimationController = AnimationController(
  //   duration: const Duration(seconds: 1),
  //   vsync: this,
  // );
  // late final Animation<double> _fadeAnimation =
  //     Tween(begin: 0.0, end: 1.0).animate(_fadeAnimationController);

  @override
  void initState() {
    super.initState();
    _alignAnimationController = AnimationController(
      duration: const Duration(
          seconds:
              4), //15 is good //8 is good for new //8 is final //4 for Curves.slowMiddle
      vsync: this,
    )..repeat(reverse: true);

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _alignAnimationController,
        //curve: Curves.easeInOutCubic,
        curve: Curves.slowMiddle,
      ),
    );

    // Listen to the playing state of the audio player
    //   final audioPlayerProvider =
    //       Provider.of<AudioPlayerProvider>(context, listen: false);
    //   audioPlayerProvider.addListener(_audioPlayerListener);
    // }

    // void _audioPlayerListener() {
    //   final audioPlayerProvider =
    //       Provider.of<AudioPlayerProvider>(context, listen: false);
    //   if (audioPlayerProvider.isPlaying) {
    //     _controller.repeat(reverse: true);
    //   } else {
    //     _controller.stop();
    //   }

    _fadeAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.5).animate(_fadeAnimationController);
  }

  @override
  void dispose() {
    _alignAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  int _keyValueCounter = 1;
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
          iconSize: 40,
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
            _fadeAnimationController.forward(from: 0);
            // counter++;

            print(
                'printingg index of previous song from main player ${audioPlayerProvider.previousSongIndex} and currentplaying id is ${currentlyPlayingSong!.id}');
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

                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: Row(
                    key: ValueKey(_keyValueCounter++),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // flex: 3,
                        //flex: 6,
                        flex: 5,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playPreviousSong,
                          child: Opacity(
                            opacity: 0.3,
                            child: QueryArtworkWidget(
                              // id: currentlyPlayingSong!.id! + 1,

                              id: audioPlayerProvider.previousSongIndex!.id!,
                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 350,
                              // artworkWidth: 40,

                              artworkBorder: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(70, 68, 137, 255),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 350.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 50,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! < 0) {
                              // Swiped left
                              audioPlayerProvider.playNextSong();
                              _alignAnimationController.repeat(reverse: true);
                            } else if (details.primaryVelocity! > 0) {
                              // Swiped right
                              audioPlayerProvider.playPreviousSong();
                              _alignAnimationController.repeat(reverse: true);
                            }
                          },
                          onTap: () {
                            if (audioPlayerProvider.isPlaying) {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPause();
                              _alignAnimationController.stop();
                            } else {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPlay(currentlyPlayingSong!.filePath);

                              //  _alignAnimationController.repeat(reverse: true);

                              if (_alignAnimationController.status ==
                                  AnimationStatus.reverse) {
                                _alignAnimationController.reverse().then(
                                  (_) {
                                    _alignAnimationController.repeat(
                                        reverse: true);
                                  },
                                );
                              } else {
                                _alignAnimationController.repeat(reverse: true);
                              }
                            }

                            // if (audioPlayerProvider.isPlaying) {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPause();
                            // } else {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPlay(currentlyPlayingSong.filePath);
                            // }
                          },
                          child: AlignTransition(
                            alignment: _alignAnimation,
                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong!.id!,
                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 380,
                              artworkWidth: 300,

                              artworkBorder: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.fill,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(22, 68, 137, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 380.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        //  flex: 3,
                        //flex: 6,
                        flex: 5,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playNextSong,
                          child: Opacity(
                            // opacity: _visible ? 0.5 : 1.0,
                            opacity: 0.3,

                            // opacity: _fadeAnimation,
                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong.id! - 1,

                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 350,
                              // artworkWidth: 40,

                              artworkBorder: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(70, 68, 137, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 350.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                              pauseAfterRound: const Duration(seconds: 1),
                              //startPadding: 10.0,
                              startPadding: 0.0,
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
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 0.0,
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
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        audioPlayerProvider.playPreviousSong();
                        _alignAnimationController.repeat(reverse: true);
                      },
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
                      shouldRebuild: (previous, current) => previous != current,
                      builder: (_, currentIcon, __) {
                        return IconButton(
                          icon: Icon(
                            currentIcon,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (audioPlayerProvider.isPlaying) {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPause();
                              _alignAnimationController.stop();
                            } else {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPlay(currentlyPlayingSong.filePath);
                              // _alignAnimationController.repeat(reverse: true);

                              if (_alignAnimationController.status ==
                                  AnimationStatus.reverse) {
                                _alignAnimationController.reverse().then(
                                  (_) {
                                    _alignAnimationController.repeat(
                                        reverse: true);
                                  },
                                );
                              } else {
                                _alignAnimationController.repeat(reverse: true);
                              }

                              // if (_alignAnimationController.status ==
                              //         AnimationStatus.completed ||
                              //     _alignAnimationController.status ==
                              //         AnimationStatus.reverse) {
                              //   _alignAnimationController.reverse();
                              // } else {
                              //   _alignAnimationController.repeat(reverse: true);
                              // }
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        audioPlayerProvider.playNextSong();
                        _alignAnimationController.repeat(reverse: true);
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





/*

//with animated opacity

import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainPlayer extends StatefulWidget {
  const MainPlayer({super.key});

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<AlignmentGeometry> _alignAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15), //15 is good
      vsync: this,
    )..repeat(reverse: true);

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Listen to the playing state of the audio player
    //   final audioPlayerProvider =
    //       Provider.of<AudioPlayerProvider>(context, listen: false);
    //   audioPlayerProvider.addListener(_audioPlayerListener);
    // }

    // void _audioPlayerListener() {
    //   final audioPlayerProvider =
    //       Provider.of<AudioPlayerProvider>(context, listen: false);
    //   if (audioPlayerProvider.isPlaying) {
    //     _controller.repeat(reverse: true);
    //   } else {
    //     _controller.stop();
    //   }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  bool _visible = true;
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
          iconSize: 40,
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

                AnimatedOpacity(
                  opacity: _visible ? 0.0 : 1.0,
                  duration: const Duration(seconds: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playPreviousSong,
                          child: QueryArtworkWidget(
                            id: currentlyPlayingSong!.id! + 1,
                            type: ArtworkType.AUDIO,
                            size: 500,
                            quality: 100,
                            artworkHeight: 350,
                            // artworkWidth: 40,

                            artworkBorder: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                            //  artworkClipBehavior: Clip.hardEdge,

                            artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(22, 68, 137, 255),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                              ),
                              // Set desired width and height for the box
                              width: 300.0, // Adjust as needed
                              // height: 63.0, // Adjust as needed
                              height: 300.0,
                              child: const Icon(
                                Icons.music_note_outlined,
                                color: Color.fromARGB(140, 64, 195, 255),
                                size: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 50,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! < 0) {
                              // Swiped left
                              audioPlayerProvider.playNextSong();
                            } else if (details.primaryVelocity! > 0) {
                              // Swiped right
                              audioPlayerProvider.playPreviousSong();
                            }
                          },
                          onTap: () {
                            if (audioPlayerProvider.isPlaying) {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPause();
                              _controller.stop();
                            } else {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPlay(currentlyPlayingSong.filePath);

                              _controller.repeat(reverse: true);
                            }

                            // if (audioPlayerProvider.isPlaying) {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPause();
                            // } else {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPlay(currentlyPlayingSong.filePath);
                            // }
                          },
                          child: AlignTransition(
                            alignment: _alignAnimation,
                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong!.id!,
                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 380,
                              artworkWidth: 300,

                              artworkBorder: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.fill,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(22, 68, 137, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 300.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playNextSong,
                          child: QueryArtworkWidget(
                            id: currentlyPlayingSong.id! - 1,

                            type: ArtworkType.AUDIO,
                            size: 500,
                            quality: 100,
                            artworkHeight: 350,
                            // artworkWidth: 40,

                            artworkBorder: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                            //  artworkClipBehavior: Clip.hardEdge,

                            artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(22, 68, 137, 255),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              // Set desired width and height for the box
                              width: 300.0, // Adjust as needed
                              // height: 63.0, // Adjust as needed
                              height: 300.0,
                              child: const Icon(
                                Icons.music_note_outlined,
                                color: Color.fromARGB(140, 64, 195, 255),
                                size: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                              //startPadding: 10.0,
                              startPadding: 0.0,
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
                              startPadding: 0.0,
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
                        setState(() {
                          _visible = !_visible;
                        });
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
                        setState(() {
                          _visible = !_visible;
                        });
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

*/



/*
//with TweenAnimationBuilder 
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MainPlayer extends StatelessWidget {
  const MainPlayer({super.key});

  static final colortween = ColorTween(
      begin: const Color.fromARGB(22, 255, 255, 255),
      end: Color.fromARGB(255, 255, 255, 255));
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    // final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),

      tween: ColorTween(
          begin: Colors.transparent, end: Color.fromARGB(255, 255, 255, 255)),
      //tween: colortween,
      builder: (_, Color? color1, Widget? myChild) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(color1!, BlendMode.modulate),
          child: myChild,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 40,
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playPreviousSong,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color.fromARGB(92, 255, 255, 255),
                                BlendMode.modulate),
                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong!.id! + 1,
                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 350,
                              // artworkWidth: 40,

                              artworkBorder: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(22, 68, 137, 255),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 300.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 50,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! < 0) {
                              // Swiped left
                              audioPlayerProvider.playNextSong();
                            } else if (details.primaryVelocity! > 0) {
                              // Swiped right
                              audioPlayerProvider.playPreviousSong();
                            }
                          },
                          onTap: () {
                            audioPlayerProvider.isPlaying
                                ? audioPlayerProvider.juzoxAudioPlayerService
                                    .juzoxPause()
                                : audioPlayerProvider.juzoxAudioPlayerService
                                    .juzoxPlay(currentlyPlayingSong.filePath);

                            // if (audioPlayerProvider.isPlaying) {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPause();
                            // } else {
                            //   audioPlayerProvider.juzoxAudioPlayerService
                            //       .juzoxPlay(currentlyPlayingSong.filePath);
                            // }
                          },
                          child: TweenAnimationBuilder(
                            duration: Duration(seconds: 5),

                            // tween: ColorTween(
                            //     begin: const Color.fromARGB(22, 255, 255, 255),
                            //     end: Color.fromARGB(255, 255, 255, 255)),
                            tween: colortween,
                            builder: (_, Color? color1, Widget? myChild) {
                              return ColorFiltered(
                                  // colorFilter: ColorFilter.mode(
                                  //     Color.fromARGB(107, 255, 255, 255),
                                  //     BlendMode.modulate),
                                  colorFilter: ColorFilter.mode(
                                      color1!, BlendMode.modulate),
                                  // child: Image.asset('assets/images/juzox-logo.png'),
                                  child:
                                      myChild); //by setting this way, the queryartwork image wont get rebuild unnecessary during the animation time
                            },

                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong!.id!,
                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 380,
                              artworkWidth: 300,

                              artworkBorder: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.fill,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(22, 68, 137, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 300.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: audioPlayerProvider.playNextSong,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color.fromARGB(107, 255, 255, 255),
                                BlendMode.modulate),
                            child: QueryArtworkWidget(
                              id: currentlyPlayingSong.id! - 1,

                              type: ArtworkType.AUDIO,
                              size: 500,
                              quality: 100,
                              artworkHeight: 350,
                              // artworkWidth: 40,

                              artworkBorder: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              //  artworkClipBehavior: Clip.hardEdge,

                              artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(22, 68, 137, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // Set desired width and height for the box
                                width: 300.0, // Adjust as needed
                                // height: 63.0, // Adjust as needed
                                height: 300.0,
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                //startPadding: 10.0,
                                startPadding: 0.0,
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
                                startPadding: 0.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}

String formatDuration(double durationInSeconds) {
  int minutes = (durationInSeconds / 60).floor();
  int seconds = (durationInSeconds % 60).floor();
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
*/

/*

//single image but large size , width adjusted to slideer

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

                Flexible(
                  flex: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flexible(
                      //   flex: 3,
                      //   child: QueryArtworkWidget(
                      //     id: currentlyPlayingSong!.id! + 1,
                      //     type: ArtworkType.AUDIO,
                      //     size: 500,
                      //     quality: 100,
                      //     artworkHeight: 270,
                      //     artworkWidth: 50,

                      //     artworkBorder: const BorderRadius.all(
                      //       Radius.circular(12),
                      //     ),
                      //     //  artworkClipBehavior: Clip.hardEdge,

                      //     artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                      //     artworkFit: BoxFit.cover,
                      //     nullArtworkWidget: Container(
                      //       decoration: const BoxDecoration(
                      //         color: Color.fromARGB(22, 68, 137, 255),
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(12),
                      //         ),
                      //       ),
                      //       // Set desired width and height for the box
                      //       width: 300.0, // Adjust as needed
                      //       // height: 63.0, // Adjust as needed
                      //       height: 300.0,
                      //       child: const Icon(
                      //         Icons.music_note_outlined,
                      //         color: Color.fromARGB(140, 64, 195, 255),
                      //         size: 300,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Spacer(),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        flex: 12,
                        child: QueryArtworkWidget(
                          id: currentlyPlayingSong!.id!,
                          type: ArtworkType.AUDIO,
                          size: 500,
                          quality: 100,
                          artworkHeight: 500,
                          artworkWidth: 800,

                          artworkBorder: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          //  artworkClipBehavior: Clip.hardEdge,

                          artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(22, 68, 137, 255),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            // Set desired width and height for the box
                            width: 300.0, // Adjust as needed
                            // height: 63.0, // Adjust as needed
                            height: 300.0,
                            child: const Icon(
                              Icons.music_note_outlined,
                              color: Color.fromARGB(140, 64, 195, 255),
                              size: 300,
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(
                        width: 24,
                      ),
                      // Flexible(
                      //   flex: 3,
                      //   child: QueryArtworkWidget(
                      //     id: currentlyPlayingSong.id! - 1,

                      //     type: ArtworkType.AUDIO,
                      //     size: 500,
                      //     quality: 100,
                      //     artworkHeight: 270,
                      //     artworkWidth: 50,

                      //     artworkBorder: const BorderRadius.all(
                      //       Radius.circular(12),
                      //     ),
                      //     //  artworkClipBehavior: Clip.hardEdge,

                      //     artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                      //     artworkFit: BoxFit.cover,
                      //     nullArtworkWidget: Container(
                      //       decoration: const BoxDecoration(
                      //         color: Color.fromARGB(22, 68, 137, 255),
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(12),
                      //         ),
                      //       ),
                      //       // Set desired width and height for the box
                      //       width: 300.0, // Adjust as needed
                      //       // height: 63.0, // Adjust as needed
                      //       height: 300.0,
                      //       child: const Icon(
                      //         Icons.music_note_outlined,
                      //         color: Color.fromARGB(140, 64, 195, 255),
                      //         size: 300,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
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
                              //startPadding: 10.0,
                              startPadding: 0.0,
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
                              startPadding: 0.0,
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
*/