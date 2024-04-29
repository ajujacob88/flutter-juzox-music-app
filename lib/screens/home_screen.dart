import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  String currentSongTitle = "";
  String currentSongArtwork = ""; // Optional for displaying artwork

  @override
  void initState() {
    super.initState();
    // Request storage permission on initialization

    requestStoragePermission().then((granted) {
      if (granted) {
        // Load audio files here (explained later)
      }
    });
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
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
      body: player.playing
          ? buildNowPlaying()
          : const Center(child: Text('No song playing')),
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
}
