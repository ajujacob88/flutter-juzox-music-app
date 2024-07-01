import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Ensure this import is correct

class PlaylistSongsPage extends StatelessWidget {
  final String playlistName;

  const PlaylistSongsPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final playlistSongs =
        audioPlayerProvider.userPlaylistSongs[playlistName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: ListView.builder(
        itemCount: playlistSongs.length,
        itemBuilder: (context, index) {
          final song = playlistSongs[index];
          return ListTile(
            leading: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(8),
              artworkClipBehavior: Clip.hardEdge,
              artworkWidth: 50,
              artworkHeight: 50,
              id: song.id!,
              artworkColor: const Color.fromARGB(249, 7, 69, 116),
              artworkBlendMode: BlendMode.screen,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(22, 68, 137, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 40.0,
                height: 40.0,
                child: const Icon(
                  Icons.music_note_outlined,
                  color: Color.fromARGB(140, 64, 195, 255),
                  size: 30,
                ),
              ),
            ),
            title: Text(song.title!),
            onTap: () {
              // Implement the functionality to play the selected song
            },
          );
        },
      ),
    );
  }
}
