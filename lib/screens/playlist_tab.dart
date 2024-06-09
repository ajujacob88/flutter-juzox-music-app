//NOT ENABLED THIS TILL NOW

import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';

import 'package:juzox_music_app/models/music_model.dart';
import 'package:provider/provider.dart';

class PlaylistTab extends StatefulWidget {
  const PlaylistTab({super.key});

  @override
  State<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  List<String> userPlaylists = ['Favorite'];
  List<String> suggestedPlaylists = [
    'Recently Played',
    'Most Played',
    'Last Added'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'My Playlist',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const CreatePlaylistButton(),
          ...userPlaylists
              .map((playlistName) => PlaylistTile(playlistName: playlistName)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Suggested Playlists',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...suggestedPlaylists.map((playlistName) =>
              SuggestedPlaylistTile(playlistName: playlistName)),
        ],
      ),
    );
  }
}

class CreatePlaylistButton extends StatelessWidget {
  const CreatePlaylistButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Create Playlist'),
      onTap: () {
        // Implement the functionality to create a new playlist
      },
    );
  }
}

class PlaylistTile extends StatelessWidget {
  final String playlistName;

  const PlaylistTile({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlistName),
      onTap: () {
        // Implement the functionality to open and play the playlist
      },
    );
  }
}

class SuggestedPlaylistTile extends StatelessWidget {
  final String playlistName;

  const SuggestedPlaylistTile({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlistName),
      onTap: () {
        // Implement the functionality to open and play the suggested playlist
      },
    );
  }
}
