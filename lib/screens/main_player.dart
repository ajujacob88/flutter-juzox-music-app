import 'dart:math';

import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
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

  // static const double _sideArtworkHeight = 350;
  // static const double _mainArtworkHeight = _sideArtworkHeight * 1.086;

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    // final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    double screenHeight = MediaQuery.of(context).size.height;
    //using layout builder is better than mediaquery,, i used mediaquery here just to learn
    debugPrint('screen height is $screenHeight ');
    bool isSmallerScreen =
        screenHeight < 730; // found out this value by printing //610//730

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
        body: LayoutBuilder(
          builder: (context, constraints) {
            double bodyScreenHeight = constraints
                .maxHeight; //screen height if the body, since layout builder is wrapped on body,,, layout builder will give he constraints of its parent widget..we can wrap it anywhere
            double bodyScreenWidth = constraints.maxWidth;
            debugPrint(
                'constraint.max screen height of the parent widget is ${constraints.maxHeight}, constraint.maxscreen width is ${constraints.maxWidth}');
            if (constraints.maxHeight > 420) {
              return Selector<AudioPlayerProvider, JuzoxMusicModel?>(
                selector: (context, audioPlayerProvider) =>
                    audioPlayerProvider.currentlyPlayingSong,
                shouldRebuild: (previous, current) => previous != current,
                builder: (context, currentlyPlayingSong, _) {
                  // _fadeAnimationControllerforicon.forward(from: 0);
                  // _iconAnimationController.forward(from: 0);
                  // _alignAnimationControllerforicon.forward(from: 0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        // height:10
                        height: !isSmallerScreen ? 10 : 0,
                      ),

                      Flexible(
                        // flex: 10,
                        //flex: !isSmallerScreen ? 10 : 8,
                        flex: bodyScreenHeight > 468 ? 10 : 8,

                        child: AnimatedSwitcher(
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
                                child: Opacity(
                                  opacity: 0.3,
                                  child: QueryArtworkWidget(
                                    // id: currentlyPlayingSong!.id! + 1,

                                    id: audioPlayerProvider.previousSong?.id ??
                                        0,
                                    type: ArtworkType.AUDIO,
                                    size: 400,
                                    quality: 80,
                                    // artworkHeight: 350,
                                    //artworkHeight: _sideArtworkHeight,
                                    // artworkWidth: 40,
                                    artworkHeight: bodyScreenHeight / 2.157,

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
                                      // height: 350.0,
                                      height: bodyScreenHeight / 2.157,
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        color:
                                            Color.fromARGB(140, 64, 195, 255),
                                        size: 30,
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
                                      _alignAnimationController.repeat(
                                          reverse: true);

                                      if (!audioPlayerProvider.isPlaying) {
                                        _fadeAnimationControllerforicon
                                            .forward();

                                        _iconAnimationController.forward();

                                        _alignAnimationControllerforicon
                                            .forward();
                                      }
                                    } else if (details.primaryVelocity! > 0) {
                                      // Swiped right
                                      audioPlayerProvider.playPreviousSong();
                                      _alignAnimationController.repeat(
                                          reverse: true);

                                      if (!audioPlayerProvider.isPlaying) {
                                        _fadeAnimationControllerforicon
                                            .forward();

                                        _iconAnimationController.forward();

                                        _alignAnimationControllerforicon
                                            .forward();
                                      }
                                    }
                                  },
                                  onTap: () {
                                    if (audioPlayerProvider.isPlaying) {
                                      audioPlayerProvider
                                          .juzoxAudioPlayerService
                                          .juzoxPause();
                                      _alignAnimationController.stop();

                                      _fadeAnimationControllerforicon.reverse();
                                      _alignAnimationControllerforicon
                                          .reverse();
                                      _iconAnimationController.reverse();
                                    } else {
                                      audioPlayerProvider
                                          .juzoxAudioPlayerService
                                          .juzoxPlay(
                                              currentlyPlayingSong!.filePath);

                                      //  _alignAnimationController.repeat(reverse: true);
                                      _fadeAnimationControllerforicon.forward();
                                      _alignAnimationControllerforicon
                                          .forward();
                                      _iconAnimationController.forward();

                                      if (_alignAnimationController.status ==
                                          AnimationStatus.reverse) {
                                        _alignAnimationController
                                            .reverse()
                                            .then(
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
                                              //artworkHeight: 380,
                                              // artworkHeight: _mainArtworkHeight,
                                              //  artworkWidth: 300,
                                              // artworkHeight: 380,
                                              // artworkWidth:
                                              //     constraints.maxWidth * 0.73,
                                              artworkHeight:
                                                  bodyScreenHeight / 1.989,
                                              artworkWidth:
                                                  bodyScreenWidth * 0.73,

                                              artworkBorder:
                                                  const BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                //  width: 300.0,
                                                width:
                                                    constraints.maxWidth * 0.73,
                                                height: 380.0,
                                                child: Icon(
                                                  Icons.music_note_outlined,
                                                  color: const Color.fromARGB(
                                                      140, 64, 195, 255),
                                                  //size: 300,
                                                  //size: 300,
                                                  // size: constraints.maxHeight /
                                                  //     2.51,
                                                  size: min(
                                                      constraints.maxHeight /
                                                          2.51,
                                                      300),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 20,
                                              right: 20,
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Selector<
                                                    AudioPlayerProvider, bool>(
                                                  selector: (context,
                                                          audioPlayerProvider) =>
                                                      audioPlayerProvider
                                                          .isPlaying,
                                                  builder: (_, isPlaying, __) {
                                                    return AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      child: isPlaying
                                                          ? const Align(
                                                              key: ValueKey(
                                                                  'animated'),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child:
                                                                  AnimatedMusicIndicator(
                                                                // key: ValueKey(
                                                                //     'animated'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        219,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                barStyle:
                                                                    BarStyle
                                                                        .solid,
                                                                size: .06,
                                                              ),
                                                            )
                                                          : const Align(
                                                              key: ValueKey(
                                                                  'static'),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child:
                                                                  StaticMusicIndicator(
                                                                // key: ValueKey(
                                                                //     'static'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        219,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                size: .1,
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                    ],
                                  ),
                                ),
                              ),
                              // Spacer(),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 5,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: QueryArtworkWidget(
                                    id: audioPlayerProvider.nextSong?.id ?? 0,
                                    type: ArtworkType.AUDIO,
                                    size: 400,
                                    quality: 80,
                                    //artworkHeight: 350,
                                    //  artworkHeight: _sideArtworkHeight,
                                    artworkHeight: bodyScreenHeight / 2.157,
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
                                      // height: 350.0,
                                      height: bodyScreenHeight / 2.157,
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        color:
                                            Color.fromARGB(140, 64, 195, 255),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //  ),

                      // const Spacer(
                      //   flex: 1,
                      // ),
                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),
                      Flexible(
                        // flex: 3,
                        flex: !isSmallerScreen ? 3 : 5,
                        child: Row(
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
                                      key: ValueKey(
                                          currentlyPlayingSong!.filePath),
                                      // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                                      text: currentlyPlayingSong.title ??
                                          'Unknown',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                      //textScaleFactor: 1.3,
                                      // blankSpace: 40.0,
                                      // velocity: 30,

                                      blankSpace: 40.0,
                                      velocity: 20,
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                      //startPadding: 10.0,
                                      startPadding: 0.0,
                                    ),
                                  ),

                                  // // const SizedBox(height: 20),

                                  SizedBox(
                                    height: 26,
                                    //  width: 330,
                                    child: Marquee(
                                      key: ValueKey(
                                          currentlyPlayingSong.filePath),
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
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                      startPadding: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Flexible(
                              flex: 1,
                              child: IconButton(
                                // onPressed: () {
                                //   if (audioPlayerProvider
                                //       .isFavorite(currentlyPlayingSong)) {
                                //     audioPlayerProvider.removeSongFromFavorites(
                                //         currentlyPlayingSong);
                                //   } else {
                                //     audioPlayerProvider.addSongToFavorites(
                                //         currentlyPlayingSong);
                                //   }
                                // },
                                onPressed: () {
                                  audioPlayerProvider
                                      .toggleFavoriteStatusOfSong(
                                          currentlyPlayingSong);
                                },
                                icon: Selector<AudioPlayerProvider, bool>(
                                  selector: (context, audioPlayerprovider) =>
                                      audioPlayerprovider
                                          .isFavorite(currentlyPlayingSong),
                                  shouldRebuild: (previous, current) =>
                                      previous != current,
                                  builder: (_, isFavorite, __) {
                                    //  debugPrint(
                                    //    'debug check 10 - in main player .contains ${audioPlayerProvider.favoriteSongs.contains(currentlyPlayingSong)} or isfavo ${audioPlayerProvider.isFavorite(currentlyPlayingSong)} and current playing song is $currentlyPlayingSong and favo songs is ${audioPlayerProvider.favoriteSongs} ');
                                    return Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    );
                                  },
                                ),
                                color: const Color.fromARGB(156, 64, 195, 255),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Transform.rotate(
                                angle: 1.5708, // Convert degrees to radians
                                child: IconButton(
                                  onPressed: () {
                                    //sample code written - for debugging - just to check the playlist is working or not
                                    // audioPlayerProvider.playSongFromList(
                                    //     audioPlayerProvider.favoriteSongs[0],
                                    //     audioPlayerProvider.favoriteSongs);
                                  },
                                  icon: const Icon(Icons.tune_outlined),
                                  color:
                                      const Color.fromARGB(156, 64, 195, 255),
                                  //iconSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const Spacer(
                      //   flex: 1,
                      // ),

                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),

                      Flexible(
                        //flex: 2,
                        flex: !isSmallerScreen ? 2 : 3,
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
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
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
                      ),

                      //SizedBox(height: 20),
                      // Control Buttons

                      // const Spacer(
                      //     //flex: 1,
                      //     ),
                      Flexible(
                        // flex: 2,
                        flex: !isSmallerScreen ? 2 : 3,
                        child: SizedBox.fromSize(
                          size: Size.infinite,
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // you can put the Wrap inside of another widget that does expand, and it will take on that size and use it. so i wraped wrap wtih SizedBox.fromSize, otherwise alignmet is taking up minimum space

                            alignment: WrapAlignment.spaceEvenly,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            //  spacing: 20,
                            children: [
                              IconButton(
                                // iconSize: 25,
                                iconSize: min(constraints.maxWidth * .07, 25),
                                icon: const Icon(
                                  CupertinoIcons.shuffle,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                // iconSize: 40,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playPreviousSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //  iconSize: 43, // Size of the circle
                                iconSize: min(constraints.maxWidth * .11, 43),
                                icon: Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    // color: Color.fromARGB(
                                    //     106, 64, 195, 255), // Circle color
                                    // color: Color.fromARGB(164, 255, 255, 255),
                                    color: Color.fromARGB(
                                        146, 255, 255, 255), //final
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _iconAnimation,
                                    // color: Colors.white,
                                    color: const Color.fromARGB(255, 0, 6, 11),
                                  ),
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
                                },
                              ),
                              IconButton(
                                // iconSize: 40,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playNextSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //  iconSize: 28,
                                iconSize: min(constraints.maxWidth * .07, 28),
                                icon: const Icon(
                                  Icons.repeat,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),

                      // const Spacer(
                      //   flex: 1,
                      // ),
                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              );
            } else {
              return Selector<AudioPlayerProvider, JuzoxMusicModel?>(
                selector: (context, audioPlayerProvider) =>
                    audioPlayerProvider.currentlyPlayingSong,
                shouldRebuild: (previous, current) => previous != current,
                builder: (context, currentlyPlayingSong, _) {
                  //  bool _verySmallerScreen = screenHeight < 292;  //using this mediaquery also works
                  bool verySmallerScreen = constraints.maxHeight < 235;
                  //using layout builder is better than mediaquery, so i used here

                  bool ultraSmallerScreen = constraints.maxHeight < 201;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      !ultraSmallerScreen
                          ? Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 25,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          // width: 250,
                                          child: Marquee(
                                            key: ValueKey(
                                                currentlyPlayingSong!.filePath),
                                            // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                                            text: currentlyPlayingSong.title ??
                                                'Unknown',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),

                                            blankSpace: 40.0,
                                            velocity: 20,
                                            pauseAfterRound:
                                                const Duration(seconds: 1),
                                            //startPadding: 10.0,
                                            startPadding: 0.0,
                                          ),
                                        ),
                                        !verySmallerScreen
                                            ? SizedBox(
                                                height: 26,
                                                //  width: 330,
                                                child: Marquee(
                                                  key: ValueKey(
                                                      currentlyPlayingSong
                                                          .filePath),
                                                  text:
                                                      "${currentlyPlayingSong.album ?? 'Unknown Album'} - ${currentlyPlayingSong.artist ?? 'Unknown Artist'} ",
                                                  style: const TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 16,
                                                  ),
                                                  blankSpace: 40.0,
                                                  velocity: 20,
                                                  pauseAfterRound:
                                                      const Duration(
                                                          seconds: 1),
                                                  startPadding: 0.0,
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    // child: IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.favorite_border),
                                    //   color: const Color.fromARGB(
                                    //       156, 64, 195, 255),
                                    // ),
                                    child: IconButton(
                                      onPressed: () {
                                        audioPlayerProvider
                                            .toggleFavoriteStatusOfSong(
                                                currentlyPlayingSong);
                                      },
                                      icon: Selector<AudioPlayerProvider, bool>(
                                        selector:
                                            (context, audioPlayerprovider) =>
                                                audioPlayerprovider.isFavorite(
                                                    currentlyPlayingSong),
                                        shouldRebuild: (previous, current) =>
                                            previous != current,
                                        builder: (_, isFavorite, __) {
                                          return Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                          );
                                        },
                                      ),
                                      color: const Color.fromARGB(
                                          156, 64, 195, 255),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Selector<AudioPlayerProvider,
                                              bool>(
                                          selector:
                                              (context, audioPlayerProvider) =>
                                                  audioPlayerProvider.isPlaying,
                                          builder: (_, isPlaying, __) {
                                            return AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: isPlaying
                                                  ? const Align(
                                                      key: ValueKey('animated'),
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                          AnimatedMusicIndicator(
                                                        // key: ValueKey('animated'),
                                                        color: Color.fromARGB(
                                                            156, 64, 195, 255),
                                                        barStyle:
                                                            BarStyle.solid,
                                                        size: .06,
                                                      ),
                                                    )
                                                  : const Align(
                                                      key: ValueKey('static'),
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                          StaticMusicIndicator(
                                                        // key: ValueKey('static'),
                                                        color: Color.fromARGB(
                                                            156, 64, 195, 255),
                                                        size: .1,
                                                      ),
                                                    ),
                                            );
                                          }),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        flex: 1,
                        // flex: !isSmallerScreen ? 2 : 3,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 0.8,
                            trackShape: const RoundedRectSliderTrackShape(),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0,
                              pressedElevation: 20.0,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 22.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.black,
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
                              return Column(
                                mainAxisSize: MainAxisSize.min,
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
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
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
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        // flex: !isSmallerScreen ? 2 : 3,
                        child: SizedBox.fromSize(
                          size: Size.infinite,
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // you can put the Wrap inside of another widget that does expand, and it will take on that size and use it. so i wraped wrap wtih SizedBox.fromSize, otherwise alignmet is taking up minimum space

                            alignment: WrapAlignment.spaceEvenly,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            //  spacing: 20,
                            children: [
                              IconButton(
                                //iconSize: 25,
                                // iconSize: constraints.maxWidth * .07,
                                iconSize: min(constraints.maxWidth * .07, 25),
                                icon: const Icon(
                                  CupertinoIcons.shuffle,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                //  iconSize: 40,
                                // iconSize: constraints.maxWidth * .1,
                                //above is ok, but when the screen size is getting too large, then icon will also gets too large
                                iconSize: min(constraints.maxWidth * .1, 40),
                                //by using min the iconsize will get the minimum value out of the 2
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playPreviousSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //iconSize: 43, // Size of the circle
                                // iconSize: constraints.maxWidth * .11,
                                iconSize: min(constraints.maxWidth * .11, 43),
                                icon: Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),

                                    color: Color.fromARGB(
                                        146, 255, 255, 255), //final
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _iconAnimation,
                                    // color: Colors.white,
                                    color: const Color.fromARGB(255, 0, 6, 11),
                                  ),
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
                                            currentlyPlayingSong!.filePath);
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
                              ),
                              IconButton(
                                // iconSize: 40,
                                // iconSize: constraints.maxWidth * .1,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playNextSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //iconSize: 28,
                                // iconSize: constraints.maxWidth * .07,
                                iconSize: min(constraints.maxWidth * .07, 28),
                                icon: const Icon(
                                  Icons.repeat,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}






/*
//copying audio player provide and main player for favo

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final JuzoxAudioPlayerService _juzoxAudioPlayerService =
      JuzoxAudioPlayerService();

  JuzoxMusicModel? _currentlyPlayingSong;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //for swaping pause button when finished playing a song
  ProcessingState _processingState = ProcessingState.idle;

  // int? _prevIndex;

  List<JuzoxMusicModel> _playlist = [];
//  List<JuzoxMusicModel> _defaultSongs = [];

  List<JuzoxMusicModel> _favoriteSongs = [];

  AudioPlayerProvider() {
    _juzoxAudioPlayerService.audioPlayer.positionStream.listen((duration) {
      _currentDuration = duration;

      notifyListeners();
    });
    _juzoxAudioPlayerService.audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });
    _juzoxAudioPlayerService.audioPlayer.playingStream.listen((isPlaying) {
      _isPlaying = isPlaying;
      notifyListeners();
    });

//for swaping pause button when finished playing a song
    _juzoxAudioPlayerService.audioPlayer.processingStateStream.listen((state) {
      _processingState = state;
      notifyListeners();

      if (state == ProcessingState.completed) {
        playNextSong();
      }
    });

    // Load favorite songs when the provider is initialized
    _loadFavoriteSongs();
  }

  JuzoxMusicModel? get currentlyPlayingSong => _currentlyPlayingSong;

  // JuzoxMusicModel? get currentlyPlayingSong {
  //   return _currentlyPlayingSong;
  // }

  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  ProcessingState get processingState => _processingState;

  JuzoxAudioPlayerService get juzoxAudioPlayerService =>
      _juzoxAudioPlayerService;

  List<JuzoxMusicModel> get favoriteSongs => _favoriteSongs;

  void setCurrentlyPlayingSong(JuzoxMusicModel song) {
    _currentlyPlayingSong = song;
    // playSong(song.filePath);
    _juzoxAudioPlayerService.juzoxPlay(song.filePath);
    notifyListeners();
  }

  void setPlaylist(List<JuzoxMusicModel> playlist) {
    _playlist = playlist;
  }

//to play previous song
  void playPreviousSong() {
    if (_currentlyPlayingSong == null || _playlist.isEmpty) return;

    final prevSong = previousSong;
    if (prevSong != null) {
      setCurrentlyPlayingSong(prevSong);
    }
  }

  JuzoxMusicModel? get previousSong {
    if (_currentlyPlayingSong != null) {
      final currentIndex = _playlist.indexOf(_currentlyPlayingSong!);
      final prevIndex =
          (currentIndex - 1 + _playlist.length) % _playlist.length;

      return _playlist[prevIndex];
    }
    return null;
  }

//to play next song
  void playNextSong() {
    if (_currentlyPlayingSong == null || _playlist.isEmpty) return;

    final nexSong = nextSong;
    if (nexSong != null) {
      setCurrentlyPlayingSong(nexSong);
    }
  }

  JuzoxMusicModel? get nextSong {
    if (_currentlyPlayingSong != null) {
      final currentIndex = _playlist.indexOf(_currentlyPlayingSong!);
      final nextIndex = (currentIndex + 1) % _playlist.length;
      return _playlist[nextIndex];
    }
    return null;
  }

//play song from a playlist/favorite/all song
  void playSongFromList(JuzoxMusicModel song, List<JuzoxMusicModel> playlist) {
    setPlaylist(playlist);
    setCurrentlyPlayingSong(song);
  }

  //for favorites
  void addSongToFavorites(JuzoxMusicModel song) {
    if (!_favoriteSongs.contains(song)) {
      // _favoriteSongs.add(song);

      //To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
      _favoriteSongs = List.from(_favoriteSongs)..add(song);
      // //or
      // _favoriteSongs = List.of(_favoriteSongs)..add(song);

      _saveFavoriteSongs();
      notifyListeners();
    }
  }

  void removeSongFromFavorites(JuzoxMusicModel song) {
    if (_favoriteSongs.contains(song)) {
      // _favoriteSongs.remove(song);
      _favoriteSongs = List.from(_favoriteSongs)..remove(song);
      // //or
      // _favoriteSongs = List.of(_favoriteSongs)..remove(song);

      _saveFavoriteSongs();
      notifyListeners();
    }
  }

  bool isFavorite(JuzoxMusicModel? song) {
    if (song == null) return false;
    return _favoriteSongs.contains(song);
  }

  //directly write the function here to call it from songs page favorite button
  void toggleFavoriteStatusOfSong(JuzoxMusicModel song) {
    !isFavorite(song)
        ? addSongToFavorites(song)
        : removeSongFromFavorites(song);
  }

  // void addMultipleSongsToFavorite(List<JuzoxMusicModel> songs){}

  // Save favorite songs to shared preferences
  Future<void> _saveFavoriteSongs() async {
    try {
      debugPrint('encoded data debugg check1');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _favoriteSongs.map((song) => song.toJson()).toList(),
      );
      /*
      //this is the same one written above
      final String encodedData2 = jsonEncode(
        _favoriteSongs.map(
          (song) {
            return song.toJson();
          },
        ).toList(),
      );
    */
      debugPrint('encoded data is $encodedData');
      await prefs.setString('favoriteSongs', encodedData);
    } catch (error) {
      debugPrint('Failed to save favorite songs: $error');
    }
  }

  // Load favorite songs from shared preferences
  Future<void> _loadFavoriteSongs() async {
    try {
      debugPrint('decoded encoded data debug check1');
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('favoriteSongs');
      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        _favoriteSongs = decodedData
            .map((json) => JuzoxMusicModel.fromJson(json))
            .toList()
            .cast<JuzoxMusicModel>();
        /*      
      //same as above
      _favoriteSongs = decodedData.map(
        (json) {
          return JuzoxMusicModel.fromJson(json);
        },
      ).toList().cast<JuzoxMusicModel>();
      */
        notifyListeners();
        debugPrint('decoded encoded data is $decodedData');
        debugPrint('decoded encoded data - _favoriteSongs is $_favoriteSongs');
      }
    } catch (error) {
      debugPrint('Failed to load favorite songs: $error');
    }
  }
}



// main player

import 'dart:math';

import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
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

  // static const double _sideArtworkHeight = 350;
  // static const double _mainArtworkHeight = _sideArtworkHeight * 1.086;

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    // final currentlyPlayingSong = audioPlayerProvider.currentlyPlayingSong;

    double screenHeight = MediaQuery.of(context).size.height;
    //using layout builder is better than mediaquery,, i used mediaquery here just to learn
    debugPrint('screen height is $screenHeight ');
    bool isSmallerScreen =
        screenHeight < 730; // found out this value by printing //610//730

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
        body: LayoutBuilder(
          builder: (context, constraints) {
            double bodyScreenHeight = constraints
                .maxHeight; //screen height if the body, since layout builder is wrapped on body,,, layout builder will give he constraints of its parent widget..we can wrap it anywhere
            double bodyScreenWidth = constraints.maxWidth;
            debugPrint(
                'constraint.max screen height of the parent widget is ${constraints.maxHeight}, constraint.maxscreen width is ${constraints.maxWidth}');
            if (constraints.maxHeight > 420) {
              return Selector<AudioPlayerProvider, JuzoxMusicModel?>(
                selector: (context, audioPlayerProvider) =>
                    audioPlayerProvider.currentlyPlayingSong,
                shouldRebuild: (previous, current) => previous != current,
                builder: (context, currentlyPlayingSong, _) {
                  // _fadeAnimationControllerforicon.forward(from: 0);
                  // _iconAnimationController.forward(from: 0);
                  // _alignAnimationControllerforicon.forward(from: 0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        // height:10
                        height: !isSmallerScreen ? 10 : 0,
                      ),

                      Flexible(
                        // flex: 10,
                        //flex: !isSmallerScreen ? 10 : 8,
                        flex: bodyScreenHeight > 468 ? 10 : 8,

                        child: AnimatedSwitcher(
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
                                child: Opacity(
                                  opacity: 0.3,
                                  child: QueryArtworkWidget(
                                    // id: currentlyPlayingSong!.id! + 1,

                                    id: audioPlayerProvider.previousSong?.id ??
                                        0,
                                    type: ArtworkType.AUDIO,
                                    size: 400,
                                    quality: 80,
                                    // artworkHeight: 350,
                                    //artworkHeight: _sideArtworkHeight,
                                    // artworkWidth: 40,
                                    artworkHeight: bodyScreenHeight / 2.157,

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
                                      // height: 350.0,
                                      height: bodyScreenHeight / 2.157,
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        color:
                                            Color.fromARGB(140, 64, 195, 255),
                                        size: 30,
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
                                      _alignAnimationController.repeat(
                                          reverse: true);

                                      if (!audioPlayerProvider.isPlaying) {
                                        _fadeAnimationControllerforicon
                                            .forward();

                                        _iconAnimationController.forward();

                                        _alignAnimationControllerforicon
                                            .forward();
                                      }
                                    } else if (details.primaryVelocity! > 0) {
                                      // Swiped right
                                      audioPlayerProvider.playPreviousSong();
                                      _alignAnimationController.repeat(
                                          reverse: true);

                                      if (!audioPlayerProvider.isPlaying) {
                                        _fadeAnimationControllerforicon
                                            .forward();

                                        _iconAnimationController.forward();

                                        _alignAnimationControllerforicon
                                            .forward();
                                      }
                                    }
                                  },
                                  onTap: () {
                                    if (audioPlayerProvider.isPlaying) {
                                      audioPlayerProvider
                                          .juzoxAudioPlayerService
                                          .juzoxPause();
                                      _alignAnimationController.stop();

                                      _fadeAnimationControllerforicon.reverse();
                                      _alignAnimationControllerforicon
                                          .reverse();
                                      _iconAnimationController.reverse();
                                    } else {
                                      audioPlayerProvider
                                          .juzoxAudioPlayerService
                                          .juzoxPlay(
                                              currentlyPlayingSong!.filePath);

                                      //  _alignAnimationController.repeat(reverse: true);
                                      _fadeAnimationControllerforicon.forward();
                                      _alignAnimationControllerforicon
                                          .forward();
                                      _iconAnimationController.forward();

                                      if (_alignAnimationController.status ==
                                          AnimationStatus.reverse) {
                                        _alignAnimationController
                                            .reverse()
                                            .then(
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
                                              //artworkHeight: 380,
                                              // artworkHeight: _mainArtworkHeight,
                                              //  artworkWidth: 300,
                                              // artworkHeight: 380,
                                              // artworkWidth:
                                              //     constraints.maxWidth * 0.73,
                                              artworkHeight:
                                                  bodyScreenHeight / 1.989,
                                              artworkWidth:
                                                  bodyScreenWidth * 0.73,

                                              artworkBorder:
                                                  const BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                //  width: 300.0,
                                                width:
                                                    constraints.maxWidth * 0.73,
                                                height: 380.0,
                                                child: Icon(
                                                  Icons.music_note_outlined,
                                                  color: const Color.fromARGB(
                                                      140, 64, 195, 255),
                                                  //size: 300,
                                                  //size: 300,
                                                  // size: constraints.maxHeight /
                                                  //     2.51,
                                                  size: min(
                                                      constraints.maxHeight /
                                                          2.51,
                                                      300),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 20,
                                              right: 20,
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Selector<
                                                    AudioPlayerProvider, bool>(
                                                  selector: (context,
                                                          audioPlayerProvider) =>
                                                      audioPlayerProvider
                                                          .isPlaying,
                                                  builder: (_, isPlaying, __) {
                                                    return AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      child: isPlaying
                                                          ? const Align(
                                                              key: ValueKey(
                                                                  'animated'),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child:
                                                                  AnimatedMusicIndicator(
                                                                // key: ValueKey(
                                                                //     'animated'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        219,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                barStyle:
                                                                    BarStyle
                                                                        .solid,
                                                                size: .06,
                                                              ),
                                                            )
                                                          : const Align(
                                                              key: ValueKey(
                                                                  'static'),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child:
                                                                  StaticMusicIndicator(
                                                                // key: ValueKey(
                                                                //     'static'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        219,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                size: .1,
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                    ],
                                  ),
                                ),
                              ),
                              // Spacer(),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 5,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: QueryArtworkWidget(
                                    id: audioPlayerProvider.nextSong?.id ?? 0,
                                    type: ArtworkType.AUDIO,
                                    size: 400,
                                    quality: 80,
                                    //artworkHeight: 350,
                                    //  artworkHeight: _sideArtworkHeight,
                                    artworkHeight: bodyScreenHeight / 2.157,
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
                                      // height: 350.0,
                                      height: bodyScreenHeight / 2.157,
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        color:
                                            Color.fromARGB(140, 64, 195, 255),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //  ),

                      // const Spacer(
                      //   flex: 1,
                      // ),
                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),
                      Flexible(
                        // flex: 3,
                        flex: !isSmallerScreen ? 3 : 5,
                        child: Row(
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
                                      key: ValueKey(
                                          currentlyPlayingSong!.filePath),
                                      // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                                      text: currentlyPlayingSong.title ??
                                          'Unknown',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                      //textScaleFactor: 1.3,
                                      // blankSpace: 40.0,
                                      // velocity: 30,

                                      blankSpace: 40.0,
                                      velocity: 20,
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                      //startPadding: 10.0,
                                      startPadding: 0.0,
                                    ),
                                  ),

                                  // // const SizedBox(height: 20),

                                  SizedBox(
                                    height: 26,
                                    //  width: 330,
                                    child: Marquee(
                                      key: ValueKey(
                                          currentlyPlayingSong.filePath),
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
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                      startPadding: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Flexible(
                              flex: 1,
                              child: IconButton(
                                // onPressed: () {
                                //   if (audioPlayerProvider
                                //       .isFavorite(currentlyPlayingSong)) {
                                //     audioPlayerProvider.removeSongFromFavorites(
                                //         currentlyPlayingSong);
                                //   } else {
                                //     audioPlayerProvider.addSongToFavorites(
                                //         currentlyPlayingSong);
                                //   }
                                // },
                                onPressed: () {
                                  // audioPlayerProvider
                                  //     .toggleFavoriteStatusOfSong(
                                  //         currentlyPlayingSong);
                                  if (audioPlayerProvider
                                          .currentlyPlayingSong !=
                                      null) {
                                    audioPlayerProvider
                                        .toggleFavoriteStatusOfSong(
                                      audioPlayerProvider.currentlyPlayingSong!,
                                    );
                                  }
                                },
                                icon: Selector<AudioPlayerProvider, bool>(
                                  selector: (context, audioPlayerprovider) =>
                                      audioPlayerprovider.isFavorite(
                                          audioPlayerprovider
                                              .currentlyPlayingSong),
                                  shouldRebuild: (previous, current) =>
                                      previous != current,
                                  builder: (_, isFavorite, __) {
                                    debugPrint(
                                        'decoded encoded data - in main player .contains ${audioPlayerProvider.favoriteSongs.contains(currentlyPlayingSong)} or isfavo ${audioPlayerProvider.isFavorite(currentlyPlayingSong)} and current playing song is $currentlyPlayingSong and favo songs is ${audioPlayerProvider.favoriteSongs} ');
                                    return Icon(
                                      // audioPlayerProvider
                                      //         .isFavorite(currentlyPlayingSong)
                                      audioPlayerProvider.favoriteSongs.any(
                                        // (element) =>
                                        //     element.id ==
                                        //     currentlyPlayingSong.id,

                                        (element) {
                                          debugPrint(
                                              'decoded encoded data - element is ${element.id} -  curr pl song - ${currentlyPlayingSong.id}');
                                          return element.id ==
                                              currentlyPlayingSong.id;
                                        },
                                      )
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    );
                                  },
                                ),
                                color: const Color.fromARGB(156, 64, 195, 255),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Transform.rotate(
                                angle: 1.5708, // Convert degrees to radians
                                child: IconButton(
                                  onPressed: () {
                                    //sample code written - for debugging - just to check the playlist is working or not
                                    // audioPlayerProvider.playSongFromList(
                                    //     audioPlayerProvider.favoriteSongs[0],
                                    //     audioPlayerProvider.favoriteSongs);
                                  },
                                  icon: const Icon(Icons.tune_outlined),
                                  color:
                                      const Color.fromARGB(156, 64, 195, 255),
                                  //iconSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const Spacer(
                      //   flex: 1,
                      // ),

                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),

                      Flexible(
                        //flex: 2,
                        flex: !isSmallerScreen ? 2 : 3,
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
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
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
                      ),

                      //SizedBox(height: 20),
                      // Control Buttons

                      // const Spacer(
                      //     //flex: 1,
                      //     ),
                      Flexible(
                        // flex: 2,
                        flex: !isSmallerScreen ? 2 : 3,
                        child: SizedBox.fromSize(
                          size: Size.infinite,
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // you can put the Wrap inside of another widget that does expand, and it will take on that size and use it. so i wraped wrap wtih SizedBox.fromSize, otherwise alignmet is taking up minimum space

                            alignment: WrapAlignment.spaceEvenly,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            //  spacing: 20,
                            children: [
                              IconButton(
                                // iconSize: 25,
                                iconSize: min(constraints.maxWidth * .07, 25),
                                icon: const Icon(
                                  CupertinoIcons.shuffle,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                // iconSize: 40,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playPreviousSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //  iconSize: 43, // Size of the circle
                                iconSize: min(constraints.maxWidth * .11, 43),
                                icon: Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    // color: Color.fromARGB(
                                    //     106, 64, 195, 255), // Circle color
                                    // color: Color.fromARGB(164, 255, 255, 255),
                                    color: Color.fromARGB(
                                        146, 255, 255, 255), //final
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _iconAnimation,
                                    // color: Colors.white,
                                    color: const Color.fromARGB(255, 0, 6, 11),
                                  ),
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
                                },
                              ),
                              IconButton(
                                // iconSize: 40,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playNextSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //  iconSize: 28,
                                iconSize: min(constraints.maxWidth * .07, 28),
                                icon: const Icon(
                                  Icons.repeat,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),

                      // const Spacer(
                      //   flex: 1,
                      // ),
                      !isSmallerScreen
                          ? const Spacer(
                              flex: 1,
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              );
            } else {
              return Selector<AudioPlayerProvider, JuzoxMusicModel?>(
                selector: (context, audioPlayerProvider) =>
                    audioPlayerProvider.currentlyPlayingSong,
                shouldRebuild: (previous, current) => previous != current,
                builder: (context, currentlyPlayingSong, _) {
                  //  bool _verySmallerScreen = screenHeight < 292;  //using this mediaquery also works
                  bool verySmallerScreen = constraints.maxHeight < 235;
                  //using layout builder is better than mediaquery, so i used here

                  bool ultraSmallerScreen = constraints.maxHeight < 201;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      !ultraSmallerScreen
                          ? Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 25,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          // width: 250,
                                          child: Marquee(
                                            key: ValueKey(
                                                currentlyPlayingSong!.filePath),
                                            // Unique key based on the song's file path. To ensure that the Marquee always starts with the song title starting position when you click a song, you can utilize the key property of the Marquee widget. By changing the key whenever the song changes, the Marquee will reset and start from the beginning.
                                            text: currentlyPlayingSong.title ??
                                                'Unknown',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),

                                            blankSpace: 40.0,
                                            velocity: 20,
                                            pauseAfterRound:
                                                const Duration(seconds: 1),
                                            //startPadding: 10.0,
                                            startPadding: 0.0,
                                          ),
                                        ),
                                        !verySmallerScreen
                                            ? SizedBox(
                                                height: 26,
                                                //  width: 330,
                                                child: Marquee(
                                                  key: ValueKey(
                                                      currentlyPlayingSong
                                                          .filePath),
                                                  text:
                                                      "${currentlyPlayingSong.album ?? 'Unknown Album'} - ${currentlyPlayingSong.artist ?? 'Unknown Artist'} ",
                                                  style: const TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 16,
                                                  ),
                                                  blankSpace: 40.0,
                                                  velocity: 20,
                                                  pauseAfterRound:
                                                      const Duration(
                                                          seconds: 1),
                                                  startPadding: 0.0,
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    // child: IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.favorite_border),
                                    //   color: const Color.fromARGB(
                                    //       156, 64, 195, 255),
                                    // ),
                                    child: IconButton(
                                      onPressed: () {
                                        audioPlayerProvider
                                            .toggleFavoriteStatusOfSong(
                                                currentlyPlayingSong);
                                      },
                                      icon: Selector<AudioPlayerProvider, bool>(
                                        selector:
                                            (context, audioPlayerprovider) =>
                                                audioPlayerprovider.isFavorite(
                                                    currentlyPlayingSong),
                                        shouldRebuild: (previous, current) =>
                                            previous != current,
                                        builder: (_, isFavorite, __) {
                                          return Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                          );
                                        },
                                      ),
                                      color: const Color.fromARGB(
                                          156, 64, 195, 255),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Selector<AudioPlayerProvider,
                                              bool>(
                                          selector:
                                              (context, audioPlayerProvider) =>
                                                  audioPlayerProvider.isPlaying,
                                          builder: (_, isPlaying, __) {
                                            return AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: isPlaying
                                                  ? const Align(
                                                      key: ValueKey('animated'),
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                          AnimatedMusicIndicator(
                                                        // key: ValueKey('animated'),
                                                        color: Color.fromARGB(
                                                            156, 64, 195, 255),
                                                        barStyle:
                                                            BarStyle.solid,
                                                        size: .06,
                                                      ),
                                                    )
                                                  : const Align(
                                                      key: ValueKey('static'),
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                          StaticMusicIndicator(
                                                        // key: ValueKey('static'),
                                                        color: Color.fromARGB(
                                                            156, 64, 195, 255),
                                                        size: .1,
                                                      ),
                                                    ),
                                            );
                                          }),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        flex: 1,
                        // flex: !isSmallerScreen ? 2 : 3,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 0.8,
                            trackShape: const RoundedRectSliderTrackShape(),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0,
                              pressedElevation: 20.0,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 22.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.black,
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
                              return Column(
                                mainAxisSize: MainAxisSize.min,
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
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
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
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        // flex: !isSmallerScreen ? 2 : 3,
                        child: SizedBox.fromSize(
                          size: Size.infinite,
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // you can put the Wrap inside of another widget that does expand, and it will take on that size and use it. so i wraped wrap wtih SizedBox.fromSize, otherwise alignmet is taking up minimum space

                            alignment: WrapAlignment.spaceEvenly,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            //  spacing: 20,
                            children: [
                              IconButton(
                                //iconSize: 25,
                                // iconSize: constraints.maxWidth * .07,
                                iconSize: min(constraints.maxWidth * .07, 25),
                                icon: const Icon(
                                  CupertinoIcons.shuffle,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                //  iconSize: 40,
                                // iconSize: constraints.maxWidth * .1,
                                //above is ok, but when the screen size is getting too large, then icon will also gets too large
                                iconSize: min(constraints.maxWidth * .1, 40),
                                //by using min the iconsize will get the minimum value out of the 2
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playPreviousSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //iconSize: 43, // Size of the circle
                                // iconSize: constraints.maxWidth * .11,
                                iconSize: min(constraints.maxWidth * .11, 43),
                                icon: Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),

                                    color: Color.fromARGB(
                                        146, 255, 255, 255), //final
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _iconAnimation,
                                    // color: Colors.white,
                                    color: const Color.fromARGB(255, 0, 6, 11),
                                  ),
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
                                            currentlyPlayingSong!.filePath);
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
                              ),
                              IconButton(
                                // iconSize: 40,
                                // iconSize: constraints.maxWidth * .1,
                                iconSize: min(constraints.maxWidth * .1, 40),
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {
                                  audioPlayerProvider.playNextSong();
                                  _alignAnimationController.repeat(
                                      reverse: true);

                                  if (!audioPlayerProvider.isPlaying) {
                                    _fadeAnimationControllerforicon.forward();

                                    _iconAnimationController.forward();

                                    _alignAnimationControllerforicon.forward();
                                  }
                                },
                              ),
                              IconButton(
                                //iconSize: 28,
                                // iconSize: constraints.maxWidth * .07,
                                iconSize: min(constraints.maxWidth * .07, 28),
                                icon: const Icon(
                                  Icons.repeat,
                                  color: Color.fromARGB(164, 255, 255, 255),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}




*/
