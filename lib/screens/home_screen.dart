import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // Import dart:io for file system access
import 'package:path_provider/path_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:juzox_music_app/models/song_model.dart'
    as MySongModel; // Assuming you save this class in a file named song_model.dart

//import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AudioPlayer();
  List<String> audioFiles = []; // List to store audio file paths

  String currentSongTitle = "";
  String currentSongArtwork = ""; // Optional for displaying artwork

  List<String> musicFiles = [];

  // static const MethodChannel audioChannel = MethodChannel('audio');

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

  Future<void> getAudioFiles() async {
    var audioFilesthis = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    var audioFiles2 = audioFilesthis.elementAt(32);
    var audioFiles3 = audioFilesthis.elementAt(18);

    audioFiles = [audioFiles2.data, audioFiles3.data];

    print(
        'debug check 222 ${audioFilesthis.length}, one song album ${audioFiles3.fileExtension}');
    // // Query Audios
    // List<AudioModel> audios = await _audioQuery.queryAudios();
    // // OnAudioQuery _audioQuery = OnAudioQuery();
    // File file = File('path');
    // try {
    //   if (file.existsSync()) {
    //     file.deleteSync();
    //     _audioQuery.scanMedia(file.path); // Scan the media 'path'
    //   }
    // } catch (e) {
    //   debugPrint('$e');
    // }

    // final audioQuery = OnAudioQuery();
    // final songs = await audioQuery.querySongs();

    // final songModels = songs
    //     .map((songInfo) => MySongModel.SongModel.fromSongInfo(songInfo))
    //     .toList();

    // print('debug songModels is $songModels');

    // final mp3Songs =
    //     songs.where((song) => song.fileExtension.endsWith('.mp3')).toList();

    // setState(() {
    //   audioFiles = mp3Songs.map((song) => song.fileExtension).toList();
    // });

    // print('debug check 5 audio files is, $mp3Songs');
    // Get external storage directory (replace with specific directory if needed)
    // final directory = await getExternalStorageDirectory();
    //final directory = await getExternalStorageDirectories();

    //final directory = await getDownloadsDirectory();
    //final directory = Directory('/storage/emulated/0/Download');

    // Directory tempDir = await getApplicationDocumentsDirectory();
    // var temp_Path = tempDir.path;
    // print("debug 20 check temp_path: $temp_Path");

    // final directory = await getExternalStorageDirectory();

    // final dir = await getExternalStorageDirectory();
    // final directory = Directory(dir!.path.toString().substring(0, 20));

    // final Directory directory = Directory((await getExternalStorageDirectory())!
    //     .path
    //     .toString()
    //     .substring(0, 20));
/*
    Directory directory = Directory('/storage/emulated/0/');

    //final directory = await getExternalStorageDirectory();

    directory.list(recursive: true).listen(
      (FileSystemEntity entity) {
        if (entity.path.contains('.mp3')) {
          audioFiles.add(entity.path);
        }

        print('debug 555 music files is $musicFiles');

        setState(() {});
      },
    );
*/
    // final directory = await getExternalStorageDirectories();

    // final directory = await Directory.getExternalStoragePublicDirectory(
    //     Directory.externalMusicDirectory);

    //final directory = await Directory.systemTemp;

    // final Directory directory = Directory((await getExternalStorageDirectory())!
    //     .path
    //     .toString()
    //     .substring(0, 20));
    // final directory = await getExternalStorageDirectory();
    // final directory =
    //     await getExternalStorageDirectories(type: StorageDirectory.downloads);

    //  final directory = await getApplicationDocumentsDirectory();

    //  Directory directory = Directory('/storage/emulated/0/');

    // final directory = await getExternalStorageDirectories(
    //   type: StorageDirectory.music,
    // );

    // final directory = await getExternalStorageDirectory();

    // List<FileSystemEntity> _files;
    // _files = directory!.listSync(recursive: true, followLinks: false);
    // print('debug files is $_files');

    // if (directory != null) {
    //   // List all files within the directory

    //   final files =
    //       await directory.listSync(recursive: true, followLinks: false);
    //   print('debug check files is $files');
    //   audioFiles = files
    //       .where((file) => file.path.endsWith('.mp3')) // Filter for MP3 files
    //       .map((file) => file.path)
    //       .toList();
    //   setState(() {}); // Update UI after getting audio files
    // }

    // final directory = await getExternalStorageDirectory();
    //  print('debug checkkk 10 directoriees is $directory');
    // if (directory != null) {
    //   // List all files within the directory
    //   final files =
    //       await directory.listSync(recursive: true, followLinks: false);
    //   print('debug check files is $files');
    //   audioFiles = files
    //       .where((file) => file.path.endsWith('.mp3')) // Filter for MP3 files
    //       .map((file) => file.path)
    //       .toList();
    //   setState(() {}); // Update UI after getting audio files
    // }

    // now checking again

    // List<FileSystemEntity> _files = [];

    // final directory = await getExternalStorageDirectory();
    // print('debug check 10 directoriees is $directory');

    // List<FileSystemEntity> files = directory!
    //     .listSync()
    //     .where((entity) => entity.path.endsWith('.mp3'))
    //     .toList();
    // setState(() {
    //   _files = files;
    // });
    // print('debug checkkk 11 files is $_files');

    // print('audios is before');
    // final List<Object?>? audios =
    //     await audioChannel.invokeMethod<List<Object?>>('getAudios');
    // print('audios is $audios');
  }

  Future<bool> requestStoragePermission() async {
    // if (await Permission.storage.shouldShowRequestRationale) {
    //   // Show a rationale to the user before requesting the permission
    //   // This is optional but can be helpful to explain why the permission is needed
    //   print(
    //       'debug check 66 rationele ${Permission.storage.shouldShowRequestRationale}');
    // }

    //var status = await Permission.storage.request();
    // var status = await Permission.camera.status;
    //var status1 = await Permission.accessMediaLocation.request();

    // var status = await Permission.manageExternalStorage.request();

    // print('debug check6 request storage permission status $status ');

    // return status == PermissionStatus.granted;

    final storageStatus = await Permission.storage.request();
    // final manageExternalStorageStatus =
    //     await Permission.manageExternalStorage.request();

    final mediastatus = await Permission.mediaLibrary.request();
    Permission.manageExternalStorage;
    Permission.storage.request();
    Permission.storage;

    // return storageStatus == PermissionStatus.granted &&
    //     manageExternalStorageStatus == PermissionStatus.granted;

    return storageStatus == PermissionStatus.granted;
  }

  Future<void> loadAndPlayAudio(
      String filePath, String songTitle, String artwork) async {
    await player.setAudioSource(AudioSource.uri(Uri.parse(filePath)));
    await player.play();
    setState(() {
      currentSongTitle = songTitle;
      currentSongArtwork = artwork;
    });
  }

  void playPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
    setState(() {}); // Update UI based on playing state
  }

  void seekTo(Duration position) {
    player.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      backgroundColor: Colors.transparent,
      body: player.playing ? buildNowPlaying() : buildBrowsePage(),
    );
  }

  Widget buildNowPlaying() {
    // return const Scaffold(
    //   backgroundColor: Colors.transparent,
    //   // appBar: AppBar(
    //   //   title: const Text('Search'),
    //   // ),
    //   body: Center(
    //     child: Text('Main Home Screen'),
    //   ),
    // );

    return Column(
      children: [
        // Display album artwork (optional)
        currentSongArtwork.isNotEmpty
            ? Image.network(currentSongArtwork)
            : Image.asset('assets/default_music.png'),
        Text(currentSongTitle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: playPause,
              icon: player.playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () => seekTo(Duration.zero), // Seek to beginning
              icon: Icon(Icons.skip_previous),
            ),
            IconButton(
              onPressed: () => seekTo(player.duration!), // Seek to end
              icon: Icon(Icons.skip_next),
            ),
          ],
        ),
        // Optional: Seek bar widget for playback progress
      ],
    );
  }

  Widget buildBrowsePage() {
    return ListView.builder(
      itemCount: audioFiles.length,
      itemBuilder: (context, index) {
        final String filePath = audioFiles[index];
        final String fileName = filePath.split('/').last; // Extract filename
        return ListTile(
          title: Text(fileName),
          onTap: () {
            loadAndPlayAudio(filePath, fileName, 'check');
          },
        );
      },
    );
  }
}
