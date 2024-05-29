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
  bool isPlaying = false;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.juzoxAudioPlayerService.audioPlayer.positionStream
        .listen((duration) {
      setState(() {
        currentDuration = duration;
      });
    });
    widget.juzoxAudioPlayerService.audioPlayer.durationStream
        .listen((duration) {
      setState(() {
        totalDuration = duration ?? Duration.zero;
      });
    });
    widget.juzoxAudioPlayerService.audioPlayer.playingStream
        .listen((isPlaying) {
      setState(() {
        this.isPlaying = isPlaying;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String songDisplayText =
        "${widget.song.title!} - ${widget.song.artist ?? 'Unknown Artist'}";

    return Container(
      // height: 200,
      color: Colors.grey[900],
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {},
                constraints:
                    BoxConstraints(), // Remove constraints to minimize the size
                padding: EdgeInsets.all(0),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
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
              ),
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
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  // valueIndicatorTextStyle: const TextStyle(
                  //   color: Colors.white,
                  //   fontSize: 20.0,
                  // ),
                ),
                child: Slider(
                  activeColor: const Color.fromARGB(193, 64, 195, 255),
                  thumbColor: Colors.lightBlueAccent,
                  inactiveColor: const Color.fromARGB(94, 64, 195, 255),
                  value: currentDuration.inSeconds.toDouble(),
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    widget.juzoxAudioPlayerService.audioPlayer
                        .seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/*
//after container clipprect design copy

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool isPlaying = false;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.juzoxAudioPlayerService.audioPlayer.positionStream
        .listen((duration) {
      setState(() {
        currentDuration = duration;
      });
    });
    widget.juzoxAudioPlayerService.audioPlayer.durationStream
        .listen((duration) {
      setState(() {
        totalDuration = duration ?? Duration.zero;
      });
    });
    widget.juzoxAudioPlayerService.audioPlayer.playingStream
        .listen((isPlaying) {
      setState(() {
        this.isPlaying = isPlaying;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String songDisplayText =
        "${widget.song.title!} - ${widget.song.artist ?? 'Unknown Artist'}";

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(80.0),
        topRight: Radius.circular(80.0),
        //  bottomLeft: Radius.circular(36.0),
        //  bottomRight: Radius.circular(36.0),
        //   bottomRight: Radius.circular(36.0),
      ),
      child: Container(
        //width: 330,
        // height: 200,
        //  color: Colors.grey[900],
        //  color: Color.fromARGB(25, 64, 195, 255),

        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(36.0), // Rounded corners
          // border: Border.all(
          //   // Border on all sides
          //   color: Colors.grey,
          //   width: 1.0,
          // ),
          // color: Color.fromARGB(25, 64, 195, 255),

          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(127, 5, 37, 73),
              // Color.fromARGB(129, 64, 195, 255),
              Color.fromARGB(95, 5, 37, 73), //this
              Color.fromARGB(95, 64, 195, 255), //this

              // Color.fromARGB(255, 5, 37, 73),

              // Color.fromARGB(163, 1, 0, 6),

              // Color.fromARGB(255, 5, 37, 73),
              // Color.fromARGB(95, 5, 37, 73),

              // Color.fromARGB(255, 5, 37, 73),
              // Color.fromARGB(161, 3, 11, 43),
              // Color.fromARGB(255, 5, 37, 73),

              // Color.fromARGB(95, 5, 37, 73), //also good
              // Color.fromARGB(255, 5, 37, 73), //also good
            ], // Adjust colors as needed

            //    begin: Alignment.topLeft, //this
            // end: Alignment.bottomRight,  //this

            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),

        //padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {},
                  constraints:
                      BoxConstraints(), // Remove constraints to minimize the size
                  padding: EdgeInsets.all(0),
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
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
                ),
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
                  child: Slider(
                    activeColor: const Color.fromARGB(193, 64, 195, 255),
                    thumbColor: Colors.lightBlueAccent,
                    inactiveColor: const Color.fromARGB(94, 64, 195, 255),
                    value: currentDuration.inSeconds.toDouble(),
                    max: totalDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      widget.juzoxAudioPlayerService.audioPlayer
                          .seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








*/
