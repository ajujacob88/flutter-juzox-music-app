import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class SelectSongsPage extends StatefulWidget {
  final String playlistName;

  SelectSongsPage({required this.playlistName});

  @override
  _SelectSongsPageState createState() => _SelectSongsPageState();
}

class _SelectSongsPageState extends State<SelectSongsPage> {
  List<JuzoxMusicModel> _selectedSongs = [];

  @override
  Widget build(BuildContext context) {
    final songs = Provider.of<AudioPlayerProvider>(context)
        .allSongs; // Replace 'allSongs' with your song list provider method

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Songs for "${widget.playlistName}"'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final isSelected = _selectedSongs.contains(song);

          return ListTile(
            title: Text(song.title!), // Adjust based on your music model
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
