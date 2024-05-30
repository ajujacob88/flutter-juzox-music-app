import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtworkMiniPlayer extends StatelessWidget {
  const ArtworkMiniPlayer({
    super.key,
    required this.song,
  });
  final JuzoxMusicModel song;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: song.id!,
      type: ArtworkType.AUDIO,
      // controller: _audioQuery,
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
    );
  }
}
