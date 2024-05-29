import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';

import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
      color: Colors.grey[900],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white),
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
          Slider(
            value: currentDuration.inSeconds.toDouble(),
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              widget.juzoxAudioPlayerService.audioPlayer
                  .seek(Duration(seconds: value.toInt()));
            },
          ),
        ],
      ),
    );
  }
}

/*
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
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                  widget.juzoxAudioPlayerService.juzoxPlaying()
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  if (audioPlayer.playing) {
                    widget.juzoxAudioPlayerService.juzoxPause();
                  } else {
                    audioPlayer.play();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: () {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.song.title!,
                      style: TextStyle(color: Colors.white)),
                  Text(widget.song.artist ?? 'Unknown Artist',
                      style: TextStyle(color: Colors.white70)),
                  StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = audioPlayer.duration ?? Duration.zero;
                      return Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      );
                    },
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

*/
