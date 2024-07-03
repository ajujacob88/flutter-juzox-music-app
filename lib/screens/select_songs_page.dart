import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class SelectSongsPage extends StatefulWidget {
  final String playlistName;

  const SelectSongsPage({super.key, required this.playlistName});

  @override
  State<SelectSongsPage> createState() => _SelectSongsPageState();
}

class _SelectSongsPageState extends State<SelectSongsPage> {
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
    final songs = Provider.of<AudioPlayerProvider>(context).allSongs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Songs for "${widget.playlistName}"'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          // final isSelected = _selectedSongs.contains(song);
          final isSelected =
              _selectedSongs.any((element) => element.id == song.id);
          // debugPrint(
          //     'debug selected songs isSelected $_selectedSongs name is ${_selectedSongs[0].title} and bool $isSelected and song is ${song.title}');
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
                  _selectedSongs.remove(song);
                } else {
                  _selectedSongs.add(song);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedSongs.isNotEmpty) {
            Provider.of<AudioPlayerProvider>(context, listen: false)
                .addSongsToPlaylist(widget.playlistName, _selectedSongs);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
