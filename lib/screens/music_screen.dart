import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  // List<MusicModel> _songs = [];

  final OnAudioQuery _audioQuery = OnAudioQuery();
  // List<SongModel> _songs = [];
  List<MusicModel> _songs = [];
  //List<String> _songs = [];

  // final List<String> songs = [
  //   'Galatta 1',
  //   'Omane 2',
  // ];

  @override
  void initState() {
    super.initState();
    // Request storage permission on initialization
    requestStoragePermission().then((granted) {
      if (granted) {
        // Load audio files here (explained later)
        getAudioFiles(); // Call function to get audio files on permission grant
      }
    });
  }

  Future<bool> requestStoragePermission() async {
    // <!-- Android 12 or below  --> need to check the os condition and the version here

    //if (Platform.isAndroid)

    final storageStatus = await Permission.storage.request();

    // <!-- applicable for Android 13 or greater  -->

    final audiosPermission = await Permission.audio.request();

    final photosPermission = await Permission.photos.request();

    final videosPermission = await Permission.videos.request();

    // return (storageStatus == PermissionStatus.granted) &&
    //     (audiosPermission == PermissionStatus.granted) &&
    //     (photosPermission == PermissionStatus.granted) &&
    //     (videosPermission == PermissionStatus.granted);

    print(
        'debug storagepermission this stor $storageStatus, audio $audiosPermission, pho $photosPermission, vid $videosPermission');
    return ((storageStatus == PermissionStatus.granted) ||
        ((audiosPermission == PermissionStatus.granted) &&
            (photosPermission == PermissionStatus.granted) &&
            (videosPermission == PermissionStatus.granted)));
  }

  Future<void> getAudioFiles() async {
    final songs = await _audioQuery.querySongs();
    // for (var element in songs) {
    //   if (element.fileExtension == 'mp3') {
    //     _songs =
    //         songs.map((songInfo) => MusicModel.fromSongInfo(songInfo)).toList();
    //   }
    // }
    // setState(() {
    // });
    // print('debugggggg ${songs[0].fileExtension}');

    _songs = songs
        // .where((songInfo) => songInfo.fileExtension.contains('mp3'))
        .where((songInfo) =>
            songInfo.fileExtension == 'mp3' || songInfo.fileExtension == 'm4a')
        .map((songInfo) => MusicModel.fromSongInfo(songInfo))
        .toList();

    setState(() {});
    //print('songs is ${_songs[3]}');
  }

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
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            final song = _songs[index];
            return ListTile(
              // leading: QueryThumbnail(
              //   song: song,
              //   quality: ThumbnailQuality.HIGH, // Adjust quality as needed
              // ), // Replace with your album art retrieval method (if needed)
              leading: Text(song.fileExtension!),
              title: Text(song.title!),
              subtitle: Text(song.artist!),
            );
          }),
    );
  }
}

// class SongModel {
//   final int id;
//   final String title;
//   final String artist;
//   final String duration;
//   final String uri;
//   final String album;

//   SongModel({
//     required this.id,
//     required this.title,
//     required this.artist,
//     required this.duration,
//     required this.uri,
//     required this.album,
//   });

//   factory SongModel.fromMap(map) {
//     return SongModel(
//       id: map['id'] as int,
//       title: map['title'] as String,
//       artist: map['artist'] as String,
//       duration: map['duration'] as String,
//       uri: map['uri'] as String,
//       album: map['album'] as String,
//     );
//   }
// }

/*
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
  */


// class SongModel {
//   final int id;
//   final String title;
//   final String artist;
//   final String duration;
//   final String filePath;

//   SongModel({
//     required this.id,
//     required this.title,
//     required this.artist,
//     required this.duration,
//     required this.filePath,
//   });

//   factory SongModel.fromSongInfo(songInfo) {
//     return SongModel(
//       id: songInfo.id,
//       title: songInfo.title,
//       artist: songInfo.artist ?? '',
//       duration: songInfo.duration,
//       filePath: songInfo.uri,
//     );
//   }
// }
