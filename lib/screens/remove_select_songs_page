import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class RemoveSelectSongsPage extends StatefulWidget {
  final String playlistName;

  const RemoveSelectSongsPage({super.key, required this.playlistName});

  @override
  State<RemoveSelectSongsPage> createState() => _RemoveSelectSongsPageState();
}

class _RemoveSelectSongsPageState extends State<RemoveSelectSongsPage> {
  List<JuzoxMusicModel> _selectedSongs = [];

  @override
  void initState() {
    super.initState();

    // Initialize _selectedSongs with the songs already in the playlist
    final existingSongs =
        Provider.of<AudioPlayerProvider>(context, listen: false)
                .userPlaylistSongs[widget.playlistName] ??
            [];
    _selectedSongs = List.from(existingSongs);
  }

  @override
  Widget build(BuildContext context) {
    //  final songs = Provider.of<AudioPlayerProvider>(context).allSongs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Songs for "${widget.playlistName}"'),
      ),
      body: Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
        selector: (_, audioPlayerProvider) => audioPlayerProvider.allSongs,
        shouldRebuild: (previous, next) => previous != next,
        builder: (_, allSongs, __) {
          return ListView.builder(
            itemCount: _selectedSongs.length,
            itemBuilder: (context, index) {
              final song = _selectedSongs[index];
              // final isSelected = _selectedSongs.contains(song);
              final isSelected =
                  _selectedSongs.any((element) => element.id == song.id);
              // debugPrint(
              //     'debug selected songg isSelected $_selectedSongs and bool $isSelected ');
              return ListTile(
                title: Text(song.title ??
                    'Unknown Title'), // Adjust based on your music model
                trailing: Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isSelected ? Colors.green : null,
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      // _selectedSongs.remove(song);
                      _selectedSongs
                          .removeWhere((element) => element.id == song.id);
                    } else {
                    //  _selectedSongs.add(song);
                    }
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  if (_selectedSongs.isNotEmpty) {
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .addSongsToPlaylist(widget.playlistName, _selectedSongs);
          //  }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}

