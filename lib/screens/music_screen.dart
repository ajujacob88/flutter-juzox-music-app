import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
              // isThreeLine: true,
              title: Text(
                song.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ), // Truncate if too long),
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
              leading: QueryArtworkWidget(
                artworkClipBehavior: Clip.none,
                controller: _audioQuery,
                id: song.id!,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(
                  Icons.music_note_rounded,
                ),
              ),
              //  trailing: MusicBarsAnimation2() //Icon(Icons.rectangle_rounded),
              trailing: _tappedSongId == song.id
                  ? const AnimatedMusicIndicator(
                      color: Color.fromARGB(128, 4, 190, 94),
                      barStyle: BarStyle.solid,
                      //  numberOfBars: 5,
                      size: .06,
                    )
                  : AnimatedMusicIndicator(
                      animate: false,
                    ),
              // : const SizedBox(width: 50.0),

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
/*
class MusicBarsAnimation2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 22, // Adjust the size as needed
        height: 24,
        child: EqualizerAnimation() // Your animation widget here
        );
  }
}
*/
// class MusicBarsAnimation extends StatefulWidget {
//   @override
//   _MusicBarsAnimationState createState() => _MusicBarsAnimationState();
// }

// class _MusicBarsAnimationState extends State<MusicBarsAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat(reverse: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [
//                 Colors.white.withOpacity(0.6),
//                 Colors.white.withOpacity(0.3),
//                 Colors.white.withOpacity(0.6),
//               ],
//               stops: [
//                 0.0,
//                 0.5,
//                 1.0,
//               ],
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           transform: Matrix4.translationValues(
//             _controller.value * 12,
//             0.0,
//             0.0,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
/*
class EqualizerAnimation extends StatefulWidget {
  @override
  _EqualizerAnimationState createState() => _EqualizerAnimationState();
}

class _EqualizerAnimationState extends State<EqualizerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) {
              final height = 50.0 * (index + 1) * _animation.value;
              return Container(
                width: 4.0,
                height: height,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 13, 13),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
*/