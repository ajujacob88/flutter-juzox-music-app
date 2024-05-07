import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:io';
import 'package:animated_music_indicator/animated_music_indicator.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

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
    // Get the width of the screen
    //final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding as a percentage of the screen width
    // final double leftPadding = screenWidth * 0.05; // 5% of screen width
    // final double rightPadding = screenWidth * 0.01; // 1% of screen width

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Songs'),
      // ),
      // backgroundColor: Colors.transparent,

      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/juzox-logo2.png',
                width: 70,
                // height: 40,
                height: 30,
                //color: const Color.fromARGB(158, 105, 240, 175),
                color: Color.fromARGB(158, 64, 195, 255),
              ),
              Expanded(
                // child: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    gradient: const LinearGradient(
                      colors: [
                        // Color.fromARGB(158, 105, 240, 175),

                        Color.fromARGB(127, 5, 37, 73),
                        Color.fromARGB(129, 64, 195, 255),
                      ], // Adjust colors as needed
                      begin: Alignment.topLeft,
                      end: Alignment
                          .bottomRight, // Adjust gradient direction as needed
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add logic to handle search button tap
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30.0),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Color.fromARGB(118, 255, 255, 255),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 20,
                        ),
                        SizedBox(width: 10.0),
                        Text('Search Music'),
                      ],
                    ),
                  ),
                ),
              ),
              //   ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.menu_outlined,
                    size: 30,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            final song = _songs[index];
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 18, right: 4),

              // contentPadding:
              //     EdgeInsets.only(left: leftPadding, right: rightPadding),

              title: Text(
                song.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              //  titleTextStyle: TextStyle(color: Colors.white),
              // titleTextStyle: Theme.of(context)
              //     .textTheme
              //     .titleMedium!
              //     .copyWith(color: Colors.red),
              subtitle: Text(
                '${song.artist!} - ${song.album}',
                overflow: TextOverflow.ellipsis,
              ),
              // This Widget will query/load image.
              // You can use/create your own widget/method using [queryArtwork].
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: QueryArtworkWidget(
                  artworkClipBehavior: Clip.none,
                  controller: _audioQuery,
                  id: song.id!,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    // Set desired width and height for the box
                    width: 50.0, // Adjust as needed
                    height: 50.0, // Adjust as needed
                    color: const Color.fromARGB(22, 4, 190, 94),
                    child: const Icon(
                      Icons.music_note_outlined,
                      color: Color.fromARGB(185, 4, 190, 94),
                      size: 30,
                    ),
                  ),
                ),
              ),

              trailing: _tappedSongId == song.id
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AnimatedMusicIndicator(
                          //color: Color.fromARGB(218, 4, 190, 94),
                          color: Colors.lightBlueAccent,
                          barStyle: BarStyle.solid,
                          //  numberOfBars: 5,
                          size: .06,
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          color: const Color.fromARGB(130, 255, 255, 255),
                          onPressed: () {
                            // Add logic to handle settings button tap
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const AnimatedMusicIndicator(
                          animate: false,
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          color: Color.fromARGB(130, 255, 255, 255),
                          onPressed: () {
                            // Add logic to handle settings button tap
                          },
                        ),
                      ],
                    ),

              onTap: () {
                setState(() {
                  _tappedSongId = song.id;
                });
              },
            );
          }),
    );
  }
}
