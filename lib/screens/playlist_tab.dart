import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';

import 'package:juzox_music_app/models/music_model.dart';
import 'package:provider/provider.dart';

class PlaylistTab extends StatefulWidget {
  final String playlistName;
  final List<JuzoxMusicModel> playlistSongs;

  const PlaylistTab(
      {super.key, required this.playlistName, required this.playlistSongs});

  @override
  State<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
      ),
      body: ListView.builder(
        itemCount: widget.playlistSongs.length,
        itemBuilder: (context, index) {
          final song = widget.playlistSongs[index];
          return ListTile(
            title: Text(song.title ?? 'Unknown Title'),
            subtitle: Text(song.artist ?? 'Unknown Artist'),
            onTap: () {
              final audioPlayerProvider =
                  Provider.of<AudioPlayerProvider>(context, listen: false);
              audioPlayerProvider.playSongFromList(song, widget.playlistSongs);
            },
          );
        },
      ),
    );
  }
}
