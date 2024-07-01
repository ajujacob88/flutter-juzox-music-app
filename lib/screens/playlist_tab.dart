//NOT ENABLED THIS TILL NOW

import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';

import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistTab extends StatefulWidget {
  const PlaylistTab({super.key});

  @override
  State<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  // List<String> userPlaylists = ['Favorite'];
  List<String> suggestedPlaylists = [
    'Recently Played',
    'Most Played',
    'Last Added'
  ];

  // void addPlaylist(String playlistName) {
  //   setState(() {
  //     userPlaylists.add(playlistName);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AudioPlayerProvider>(builder: (context, provider, child) {
        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Playlist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const CreatePlaylistButton(),
            // ...userPlaylists
            //     .map((playlistName) => PlaylistTile(playlistName: playlistName)),
            //  Text(audioPlayerProvider.userPlaylists[1]),

            ...provider.userPlaylists.map(
                (playlistName) => PlaylistTile(playlistName: playlistName)),

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
        );
      }),
    );
  }
}

// class CreatePlaylistButton extends StatelessWidget {
//   const CreatePlaylistButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.add),
//       title: const Text('Create Playlist'),
//       onTap: () {
//         // Implement the functionality to create a new playlist
//       },
//     );
//   }
// }

class PlaylistTile extends StatelessWidget {
  final String playlistName;

  const PlaylistTile({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    // Using the existing instance of AudioPlayerProvider
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return ListTile(
      leading: QueryArtworkWidget(
        artworkBorder: const BorderRadius.horizontal(
            left: Radius.circular(8), right: Radius.circular(8)),
        artworkClipBehavior: Clip.hardEdge,
        //  controller: _audioQuery,
        //   id: 1,
        id: audioPlayerProvider.allSongs[0].id!,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(22, 68, 137, 255),
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8), right: Radius.circular(8))),
          width: 40.0,
          height: 40.0,
          child: const Icon(
            Icons.music_note_outlined,
            color: Color.fromARGB(140, 64, 195, 255),
            size: 30,
          ),
        ),
      ),
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

//new
class CreatePlaylistButton extends StatelessWidget {
  const CreatePlaylistButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        // width: 40.0,
        // height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          //shape: BoxShape.rectangle,
          gradient: const LinearGradient(
            colors: [
              Colors.blue,
              Colors.green
            ], // Define your gradient colors here
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        padding: const EdgeInsets.all(8.0), // Adding some padding
        child: const Icon(
          Icons.add,
          color: Colors.white,
          // size: 28,
        ),
      ),
      title: const Text('New Playlist'),
      onTap: () {
        _showCreatePlaylistDialog(context);
      },
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Playlist'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final playlistName = _controller.text;
                if (playlistName.isNotEmpty) {
                  Provider.of<AudioPlayerProvider>(context, listen: false)
                      .addUserPlaylist(playlistName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

/*
class CreatePlaylistDialog extends StatefulWidget {
  @override
  _CreatePlaylistDialogState createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Playlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Playlist Namee',
              errorText: _errorMessage,
              labelStyle: TextStyle(color: Colors.green),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _createPlaylist(context);
          },
          child: Text('Create'),
        ),
      ],
    );
  }

  void _createPlaylist(BuildContext context) {
    final String playlistName = _controller.text.trim();
    if (playlistName.isEmpty) {
      setState(() {
        _errorMessage = 'Playlist name cannot be empty';
      });
      return;
    }

    final _PlaylistTabState? parentState =
        context.findAncestorStateOfType<_PlaylistTabState>();
    if (parentState != null &&
        parentState.userPlaylists.contains(playlistName)) {
      setState(() {
        _errorMessage = 'Playlist already exists';
      });
      return;
    }

    if (parentState != null) {
      parentState.addPlaylist(playlistName);
    }
    Navigator.of(context).pop();
  }
}
*/
