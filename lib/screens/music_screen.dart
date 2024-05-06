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
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  @override
  void initState() {
    super.initState();
    // Request storage permission on initialization
    requestStoragePermission().then((granted) {
      if (granted) {
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

    print(
        'debug storagepermission this stor $storageStatus, audio $audiosPermission, pho $photosPermission, vid $videosPermission');
    return ((storageStatus == PermissionStatus.granted) ||
        ((audiosPermission == PermissionStatus.granted) &&
            (photosPermission == PermissionStatus.granted) &&
            (videosPermission == PermissionStatus.granted)));
  }

  Future<void> getAudioFiles() async {
    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    _songs = songs
        .where((songInfo) =>
            songInfo.fileExtension == 'mp3' || songInfo.fileExtension == 'm4a')
        .map((songInfo) => JuzoxMusicModel.fromSongInfo(songInfo))
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
      body: ListView.builder(
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            final song = _songs[index];
            return ListTile(
              title: Text(song.title!),
              subtitle: Text(song.artist!),
              // This Widget will query/load image.
              // You can use/create your own widget/method using [queryArtwork].
              leading: QueryArtworkWidget(
                controller: _audioQuery,
                id: song.id!,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(
                  Icons.music_note_rounded,
                ),
              ),
            );
          }),
    );
  }
}
