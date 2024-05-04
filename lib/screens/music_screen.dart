import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  // List<MusicModel> _songs = [];

  final OnAudioQuery _audioQuery = OnAudioQuery();

  final List<String> songs = [
    'Galatta 1',
    'Omane 2',
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   //   _fetchSongs();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Songs'),
      // ),
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   title: const Text('Search'),
      // ),
      body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(songs[index]), onTap: () {});
          }),
    );
  }
}
