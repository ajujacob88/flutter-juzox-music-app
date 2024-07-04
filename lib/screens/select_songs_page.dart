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
    //  final songs = Provider.of<AudioPlayerProvider>(context).allSongs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Songs for "${widget.playlistName}"'),
      ),
      body: Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
        selector: (_, audioPlayerProvider) => audioPlayerProvider.allSongs,
        shouldRebuild: (previous, next) => previous != next,
        builder: (_, allSongs, __) {
          return ListView.builder(
            itemCount: allSongs.length,
            itemBuilder: (context, index) {
              final song = allSongs[index];
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
                      _selectedSongs.add(song);
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



/*
//using valuelistenable builder.. but here setstate is enogh, because only one widget tree,, so using setstate is enough.. The _selectedSongs list is managed entirely within the _SelectSongsPageState and doesn't directly affect other widgets. so no need to use valuelistenablebuilder here

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
  final ValueNotifier<List<JuzoxMusicModel>> _selectedSongsNotifier =
      ValueNotifier<List<JuzoxMusicModel>>([]);

  @override
  void initState() {
    super.initState();

    // Initialize _selectedSongs with the songs already in the playlist
    final existingSongs =
        Provider.of<AudioPlayerProvider>(context, listen: false)
                .userPlaylistSongs[widget.playlistName] ??
            [];
    _selectedSongsNotifier.value = List.from(existingSongs);
  }

  @override
  void dispose() {
    _selectedSongsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final songs = Provider.of<AudioPlayerProvider>(context).allSongs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Songs for "${widget.playlistName}"'),
      ),
      body: Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
        selector: (_, audioPlayerProvider) => audioPlayerProvider.allSongs,
        shouldRebuild: (previous, next) => previous != next,
        builder: (_, allSongs, __) {
          return ValueListenableBuilder<List<JuzoxMusicModel>>(
              valueListenable: _selectedSongsNotifier,
              builder: (context, selectedSongs, child) {
                return ListView.builder(
                  itemCount: allSongs.length,
                  itemBuilder: (context, index) {
                    final song = allSongs[index];
                    // final isSelected = _selectedSongs.contains(song);
                    final isSelected =
                        selectedSongs.any((element) => element.id == song.id);
                    // debugPrint(
                    //     'debug selected songg isSelected $_selectedSongs and bool $isSelected ');
                    return ListTile(
                      title: Text(song.title ??
                          'Unknown Title'), // Adjust based on your music model
                      trailing: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () {
                        //setState(() {
                        final newSelectedSongs =
                            List<JuzoxMusicModel>.from(selectedSongs);

                        if (isSelected) {
                          // _selectedSongs.remove(song);
                          // _selectedSongs
                          //     .removeWhere((element) => element.id == song.id);
                          newSelectedSongs
                              .removeWhere((element) => element.id == song.id);
                        } else {
                          //  _selectedSongs.add(song);
                          newSelectedSongs.add(song);
                        }
                        _selectedSongsNotifier.value = newSelectedSongs;
                        // });
                      },
                    );
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  if (_selectedSongs.isNotEmpty) {
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .addSongsToPlaylist(
                  widget.playlistName, _selectedSongsNotifier.value);
          //  }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
*/