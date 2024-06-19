import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/utils/format_duration.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';
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

  late AnimationController _fadeAnimationControllerforicon;
  late final Animation<double> _fadeAnimation;

  late AnimationController _iconAnimationController;
  late final Animation<double> _iconAnimation;

  late AnimationController _alignAnimationControllerforicon;
  late final Animation<AlignmentGeometry> _leftAlignAnimation;
  late final Animation<AlignmentGeometry> _rightAlignAnimation;

  @override
  void initState() {
    super.initState();

    // Align Transition Controller
    _alignAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
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

    // Animated Icon Controller
    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // _iconAnimationController.forward(); //this needs to be in build method if need to restard after each rebuilt
    // _iconAnimation =  Tween<double>(begin: 0.0, end: 1.0).animate(_iconAnimationController);
    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      // curve: Curves.linear,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInCubic,
      // reverseCurve: Curves.easeInQuart,
    ));

    // Fade Transition Controller for Icon
    _fadeAnimationControllerforicon = AnimationController(
      duration: const Duration(seconds: 5),
      reverseDuration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.8, end: 0)
        .animate(_fadeAnimationControllerforicon);

    // Align Transition Controller for Icon
    _alignAnimationControllerforicon = AnimationController(
      duration: const Duration(seconds: 5),
      reverseDuration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _leftAlignAnimation = Tween<AlignmentGeometry>(
      // begin: Alignment.center,
      // Adjust offset (0.2 = 20% from center)
      begin: const Alignment(-0.38, 0.0), //good
      // end: Alignment.centerLeft,
      end: const Alignment(-0.82, 0.0), //good
    ).animate(
      CurvedAnimation(
        parent: _alignAnimationControllerforicon,
        curve: Curves.decelerate,
        //reverseCurve: Curves.easeInCubic,
        //reverseCurve: Curves.easeInQuart,
        reverseCurve: Curves.easeInExpo,
      ),
    );

    _rightAlignAnimation = Tween<AlignmentGeometry>(
      //  begin: Alignment.center,
      begin: const Alignment(0.38, 0.0),
      // end: Alignment.centerRight,
      end: const Alignment(0.82, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _alignAnimationControllerforicon,
        curve: Curves.decelerate,
        // reverseCurve: Curves.easeInCubic,
        //reverseCurve: Curves.easeInQuart,
        reverseCurve: Curves.easeInExpo,
      ),
    );
  }

  @override
  void dispose() {
    _alignAnimationController.dispose();
    _fadeAnimationControllerforicon.dispose();
    _iconAnimationController.dispose();
    _alignAnimationControllerforicon.dispose();
    super.dispose();
  }

  int _keyValueCounter = 1;
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    // final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    if (audioPlayerProvider.isPlaying) {
      _fadeAnimationControllerforicon.forward(from: 0);
      _iconAnimationController.forward(from: 0);
      _alignAnimationControllerforicon.forward(from: 0);
    } else {
      _fadeAnimationControllerforicon.reverse();
      _iconAnimationController.reverse();
      _alignAnimationControllerforicon.reverse();

      _alignAnimationController.stop();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 5, 30, 60), //this
            Color.fromARGB(255, 1, 0, 6), //this
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //backgroundColor: const Color.fromARGB(255, 1, 14, 24),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 35, //40
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Playing',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: Selector<AudioPlayerProvider, JuzoxMusicModel?>(
            selector: (context, audioPlayerProvider) =>
                audioPlayerProvider.currentlyPlayingSong,
            shouldRebuild: (previous, current) => previous != current,
            builder: (context, currentlyPlayingSong, _) {
              // _fadeAnimationControllerforicon.forward(from: 0);
              // _iconAnimationController.forward(from: 0);
              // _alignAnimationControllerforicon.forward(from: 0);

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

                                id: audioPlayerProvider.previousSong?.id ?? 0,
                                type: ArtworkType.AUDIO,
                                size: 400,
                                quality: 80,
                                artworkHeight: 350,
                                // artworkWidth: 40,

                                artworkBorder: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                                //  artworkClipBehavior: Clip.hardEdge,

                                artworkClipBehavior:
                                    Clip.antiAliasWithSaveLayer,
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

                                if (!audioPlayerProvider.isPlaying) {
                                  _fadeAnimationControllerforicon.forward();

                                  _iconAnimationController.forward();

                                  _alignAnimationControllerforicon.forward();
                                }
                              } else if (details.primaryVelocity! > 0) {
                                // Swiped right
                                audioPlayerProvider.playPreviousSong();
                                _alignAnimationController.repeat(reverse: true);

                                if (!audioPlayerProvider.isPlaying) {
                                  _fadeAnimationControllerforicon.forward();

                                  _iconAnimationController.forward();

                                  _alignAnimationControllerforicon.forward();
                                }
                              }
                            },
                            onTap: () {
                              if (audioPlayerProvider.isPlaying) {
                                audioPlayerProvider.juzoxAudioPlayerService
                                    .juzoxPause();
                                _alignAnimationController.stop();

                                _fadeAnimationControllerforicon.reverse();
                                _alignAnimationControllerforicon.reverse();
                                _iconAnimationController.reverse();
                              } else {
                                audioPlayerProvider.juzoxAudioPlayerService
                                    .juzoxPlay(currentlyPlayingSong!.filePath);

                                //  _alignAnimationController.repeat(reverse: true);
                                _fadeAnimationControllerforicon.forward();
                                _alignAnimationControllerforicon.forward();
                                _iconAnimationController.forward();

                                if (_alignAnimationController.status ==
                                    AnimationStatus.reverse) {
                                  _alignAnimationController.reverse().then(
                                    (_) {
                                      _alignAnimationController.repeat(
                                          reverse: true);
                                    },
                                  );
                                } else {
                                  _alignAnimationController.repeat(
                                      reverse: true);
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AlignTransition(
                                  alignment: _alignAnimation,
                                  child: Stack(
                                    children: [
                                      QueryArtworkWidget(
                                        id: currentlyPlayingSong!.id!,
                                        type: ArtworkType.AUDIO,
                                        size: 400, //500
                                        quality: 80, //100
                                        artworkHeight: 380,
                                        artworkWidth: 300,

                                        artworkBorder: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        //  artworkClipBehavior: Clip.hardEdge,

                                        artworkClipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        artworkFit: BoxFit.fill,
                                        nullArtworkWidget: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                22, 68, 137, 255),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          width: 300.0,
                                          height: 380.0,
                                          child: const Icon(
                                            Icons.music_note_outlined,
                                            color: Color.fromARGB(
                                                140, 64, 195, 255),
                                            size: 300,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: Selector<AudioPlayerProvider,
                                                bool>(
                                            selector: (context,
                                                    audioPlayerProvider) =>
                                                audioPlayerProvider.isPlaying,
                                            builder: (_, isPlaying, __) {
                                              return AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: isPlaying
                                                    ? const AnimatedMusicIndicator(
                                                        key: ValueKey(
                                                            'animated'),
                                                        color: Color.fromARGB(
                                                            219, 255, 255, 255),
                                                        barStyle:
                                                            BarStyle.solid,
                                                        size: .06,
                                                      )
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 18.0),
                                                        child:
                                                            StaticMusicIndicator(
                                                          key: ValueKey(
                                                              'static'),
                                                          color: Color.fromARGB(
                                                              219,
                                                              255,
                                                              255,
                                                              255),
                                                          size: .1,
                                                        ),
                                                      ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),

                                //wrapping the 3 icons into a stack is more efficient since only 1 fade transition is required..wrapping with row wont work for aligntranisiton , so wrapped up with stack ,Using a Stack instead of a Row allows each widget to be independently positioned within the stack, which is necessary for AlignTransition to work correctly. In a Row, widgets are laid out horizontally, and their alignment within the row is constrained by the row's layout logic. This means AlignTransition cannot effectively position the widgets based on the animation because the Row imposes its own alignment rules.

                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Stack(
                                    children: [
                                      AlignTransition(
                                        alignment: _leftAlignAnimation,
                                        child: const Icon(
                                          Icons.swipe_left_alt_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: AnimatedIcon(
                                          progress: _iconAnimation,
                                          icon: AnimatedIcons.play_pause,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      AlignTransition(
                                        alignment: _rightAlignAnimation,
                                        child: const Icon(
                                          Icons.swipe_right_alt_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // FadeTransition(
                                //   opacity: _fadeAnimation,
                                //   child: AlignTransition(
                                //     alignment: _leftAlignAnimation,
                                //     child: const Icon(
                                //       Icons.swipe_left_alt_outlined,
                                //       size: 40,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                // FadeTransition(
                                //   opacity: _fadeAnimation,
                                //   child: AlignTransition(
                                //     alignment: _rightAlignAnimation,
                                //     child: const Icon(
                                //       Icons.swipe_right_alt_outlined,
                                //       size: 40,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                // FadeTransition(
                                //   opacity: _fadeAnimation,
                                //   child: AnimatedIcon(
                                //     progress: _iconAnimation,
                                //     icon: AnimatedIcons.play_pause,
                                //     size: 40,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ],
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

                              child: QueryArtworkWidget(
                                id: audioPlayerProvider.nextSong?.id ?? 0,
                                type: ArtworkType.AUDIO,
                                size: 400,
                                quality: 80,
                                artworkHeight: 350,
                                artworkBorder: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12)),
                                artworkClipBehavior:
                                    Clip.antiAliasWithSaveLayer,
                                artworkFit: BoxFit.cover,
                                nullArtworkWidget: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(70, 68, 137, 255),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  width: 300.0,
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
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          audioPlayerProvider.playPreviousSong();
                          _alignAnimationController.repeat(reverse: true);

                          if (!audioPlayerProvider.isPlaying) {
                            _fadeAnimationControllerforicon.forward();

                            _iconAnimationController.forward();

                            _alignAnimationControllerforicon.forward();
                          }
                        },
                      ),

                      //no need of selector here... because only one animated icon is here and it animation direction is controlled with _iconanimationcontroller
                      IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _iconAnimation,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          if (audioPlayerProvider.isPlaying) {
                            audioPlayerProvider.juzoxAudioPlayerService
                                .juzoxPause();
                            _alignAnimationController.stop();

                            _fadeAnimationControllerforicon.reverse();
                            _alignAnimationControllerforicon.reverse();
                            _iconAnimationController.reverse();
                          } else {
                            audioPlayerProvider.juzoxAudioPlayerService
                                .juzoxPlay(currentlyPlayingSong.filePath);
                            // _alignAnimationController.repeat(reverse: true);

                            _fadeAnimationControllerforicon.forward();
                            _alignAnimationControllerforicon.forward();
                            _iconAnimationController.forward();

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
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          audioPlayerProvider.playNextSong();
                          _alignAnimationController.repeat(reverse: true);

                          if (!audioPlayerProvider.isPlaying) {
                            _fadeAnimationControllerforicon.forward();

                            _iconAnimationController.forward();

                            _alignAnimationControllerforicon.forward();
                          }
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




/*
below ico buttons checking
   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {
                            audioPlayerProvider.playPreviousSong();
                            _alignAnimationController.repeat(reverse: true);

                            if (!audioPlayerProvider.isPlaying) {
                              _fadeAnimationControllerforicon.forward();

                              _iconAnimationController.forward();

                              _alignAnimationControllerforicon.forward();
                            }
                          },
                        ),
                      ),

                      //old one
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

                                _fadeAnimationControllerforicon.reverse();
                                _alignAnimationControllerforicon.reverse();
                                _iconAnimationController.reverse();
                              } else {
                                audioPlayerProvider.juzoxAudioPlayerService
                                    .juzoxPlay(currentlyPlayingSong.filePath);
                                // _alignAnimationController.repeat(reverse: true);

                                _fadeAnimationControllerforicon.forward();
                                _alignAnimationControllerforicon.forward();
                                _iconAnimationController.forward();

                                if (_alignAnimationController.status ==
                                    AnimationStatus.reverse) {
                                  _alignAnimationController.reverse().then(
                                    (_) {
                                      _alignAnimationController.repeat(
                                          reverse: true);
                                    },
                                  );
                                } else {
                                  _alignAnimationController.repeat(
                                      reverse: true);
                                }
                              }
                            },
                          );
                        },
                      ),

                      //with selector - but actually no need of selector here 
                      Expanded(
                        child: Selector<AudioPlayerProvider, bool>(
                          selector: (context, audioPlayerProvider) =>
                              audioPlayerProvider.isPlaying,
                          builder: (context, isPlaying, child) {
                            return IconButton(
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _iconAnimation,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (audioPlayerProvider.isPlaying) {
                                    audioPlayerProvider.juzoxAudioPlayerService
                                        .juzoxPause();
                                    _alignAnimationController.stop();

                                    _fadeAnimationControllerforicon.reverse();
                                    _alignAnimationControllerforicon.reverse();
                                    _iconAnimationController.reverse();
                                  } else {
                                    audioPlayerProvider.juzoxAudioPlayerService
                                        .juzoxPlay(
                                            currentlyPlayingSong.filePath);
                                    // _alignAnimationController.repeat(reverse: true);

                                    _fadeAnimationControllerforicon.forward();
                                    _alignAnimationControllerforicon.forward();
                                    _iconAnimationController.forward();

                                    if (_alignAnimationController.status ==
                                        AnimationStatus.reverse) {
                                      _alignAnimationController.reverse().then(
                                        (_) {
                                          _alignAnimationController.repeat(
                                              reverse: true);
                                        },
                                      );
                                    } else {
                                      _alignAnimationController.repeat(
                                          reverse: true);
                                    }
                                  }
                                });
                          },
                        ),
                      ),

                      //this below is the correct one
                      Expanded(
                        child: IconButton(
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: _iconAnimation,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (audioPlayerProvider.isPlaying) {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPause();
                              _alignAnimationController.stop();

                              _fadeAnimationControllerforicon.reverse();
                              _alignAnimationControllerforicon.reverse();
                              _iconAnimationController.reverse();
                            } else {
                              audioPlayerProvider.juzoxAudioPlayerService
                                  .juzoxPlay(currentlyPlayingSong.filePath);
                              // _alignAnimationController.repeat(reverse: true);

                              _fadeAnimationControllerforicon.forward();
                              _alignAnimationControllerforicon.forward();
                              _iconAnimationController.forward();

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
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {
                            audioPlayerProvider.playNextSong();
                            _alignAnimationController.repeat(reverse: true);

                            if (!audioPlayerProvider.isPlaying) {
                              _fadeAnimationControllerforicon.forward();

                              _iconAnimationController.forward();

                              _alignAnimationControllerforicon.forward();
                            }
                          },
                        ),
                      ),
                    ],
                  ),



                  */
