import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:io'; // Import dart:io for file system access
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  List<String> audioFiles = []; // List to store audio file paths

  String currentSongTitle = "";
  String currentSongArtwork = ""; // Optional for displaying artwork

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
    print('debug check 5 getaudiofiles');
    // Get external storage directory (replace with specific directory if needed)
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      // List all files within the directory
      final files = await directory.listSync(recursive: true);
      audioFiles = files
          .where((file) => file.path.endsWith('.mp3')) // Filter for MP3 files
          .map((file) => file.path)
          .toList();
      setState(() {}); // Update UI after getting audio files
    }
  }

  Future<bool> requestStoragePermission() async {
    // if (await Permission.storage.shouldShowRequestRationale) {
    //   // Show a rationale to the user before requesting the permission
    //   // This is optional but can be helpful to explain why the permission is needed
    //   print(
    //       'debug check 66 rationele ${Permission.storage.shouldShowRequestRationale}');
    // }

    var status = await Permission.storage.request();
    // var status = await Permission.camera.status;
    print('debug check6 request storage permission status $status');

    return status == PermissionStatus.granted;
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
