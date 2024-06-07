import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:juzox_music_app/utils/permission_handler.dart';
import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';
import 'package:juzox_music_app/widgets/mini_player.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';

import 'package:just_audio/just_audio.dart';

import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/music_screen.dart';
import 'package:juzox_music_app/widgets/juzox_bottom_navigation_bar.dart';

import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final ValueNotifier<int> _currentPageIndexNotifier = ValueNotifier<int>(0);
  // final ValueNotifier<JuzoxMusicModel?> _currentlyPlayingSongNotifier =
  //     ValueNotifier<JuzoxMusicModel?>(null);

  // final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);
  // final ValueNotifier<Duration> _currentDurationNotifier =
  //     ValueNotifier<Duration>(Duration.zero);
  // final ValueNotifier<Duration> _totalDurationNotifier =
  //     ValueNotifier<Duration>(Duration.zero);

  // //for swaping pause button when finished playing a song
  // final ValueNotifier<ProcessingState> _processingStateNotifier =
  //     ValueNotifier<ProcessingState>(ProcessingState.idle);

  // final JuzoxAudioPlayerService _juzoxAudioPlayerService =
  //     JuzoxAudioPlayerService();

  @override
  void initState() {
    super.initState();

//     _juzoxAudioPlayerService.audioPlayer.positionStream.listen((duration) {
//       _currentDurationNotifier.value = duration;
//     });
//     _juzoxAudioPlayerService.audioPlayer.durationStream.listen((duration) {
//       _totalDurationNotifier.value = duration ?? Duration.zero;
//     });
//     _juzoxAudioPlayerService.audioPlayer.playingStream.listen((isPlaying) {
//       _isPlayingNotifier.value = isPlaying;
//     });

// //for swaping pause button when finished playing a song
//     _juzoxAudioPlayerService.audioPlayer.processingStateStream.listen((state) {
//       _processingStateNotifier.value = state;
//     });
  }

  @override
  void dispose() {
    _currentPageIndexNotifier.dispose();
    // _currentlyPlayingSongNotifier.dispose();
    // _isPlayingNotifier.dispose();
    // _currentDurationNotifier.dispose();
    // _totalDurationNotifier.dispose();
    // _processingStateNotifier.dispose();
    super.dispose();
  }

  // void _playSong(String url) {
  //   _juzoxAudioPlayerService.juzoxPlay(url);
  // }

  @override
  Widget build(BuildContext context) {
    // final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return ValueListenableBuilder<int>(
      valueListenable: _currentPageIndexNotifier,
      builder: (context, currentPageIndex, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          bottomNavigationBar: JuzoxBottomNavigationBar(
            onCurrentPageChanged: (newIndex) {
              _currentPageIndexNotifier.value = newIndex;
              //   print('debug check 1 currentpageindex = $newIndex');
            },
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: currentPageIndex,
                children: const [
                  HomeScreen(),
                  MusicScreen(
                      // onSongSelected: _onSongSelected,
                      //    isPlayingNotifier: _isPlayingNotifier,
                      ),
                  LibraryScreen(),
                ],
              ),
              // ValueListenableBuilder<JuzoxMusicModel?>(
              //   valueListenable: _currentlyPlayingSongNotifier,
              //   builder: (context, currentlyPlayingSong, child) {

              Selector<AudioPlayerProvider, JuzoxMusicModel?>(
                selector: (context, provider) => provider.currentlyPlayingSong,
                shouldRebuild: (previous, current) => previous != current,
                builder: (context, song, child) {
                  if (song != null) {
                    return Positioned(
                      bottom: 54,
                      left: 45,
                      child: MiniPlayer(
                        song: song,
                        // ... other MiniPlayer arguments
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

/*
              Consumer<AudioPlayerProvider>(
                  builder: (context, audioPlayerProvider, child) {
                if (audioPlayerProvider.currentlyPlayingSong != null) {
                  return Positioned(
                    bottom: 54, //height of bottom nav bar
                    left: 45,
                    child: MiniPlayer(
                      song: audioPlayerProvider.currentlyPlayingSong!,
                      //      juzoxAudioPlayerService: _juzoxAudioPlayerService,
                      // isPlaying: _isPlayingNotifier,
                      // currentDuration: _currentDurationNotifier,
                      // totalDuration: _totalDurationNotifier,
                      // processingState: _processingStateNotifier,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              })

              */
              // if (audioPlayerProvider.currentlyPlayingSong != null)
              //   Positioned(
              //     bottom: 54, //height of bottom nav bar
              //     left: 45,
              //     child: MiniPlayer(
              //       song: audioPlayerProvider.currentlyPlayingSong!,
              //       //      juzoxAudioPlayerService: _juzoxAudioPlayerService,
              //       // isPlaying: _isPlayingNotifier,
              //       // currentDuration: _currentDurationNotifier,
              //       // totalDuration: _totalDurationNotifier,
              //       // processingState: _processingStateNotifier,
              //     ),
              //   )
              // else
              //   SizedBox()

              //       },
              //      ),
            ],
          ),
        );
      },
    );
  }

  // void _onSongSelected(JuzoxMusicModel song) {
  //   // final audioPlayerProvider2 =
  //   //     Provider.of<AudioPlayerProvider>(context, listen: false);

  //   // _currentlyPlayingSongNotifier.value = song;
  //   // audioPlayerProvider2.setCurrentlyPlayingSong(song);
  //   // _playSong(song.filePath);

  //   Provider.of<AudioPlayerProvider>(context, listen: false)
  //       .setCurrentlyPlayingSong(song);
  // }

  // void _onSongSelected(JuzoxMusicModel song) {
  //   _currentlyPlayingSongNotifier.value = song;
  //   _playSong(song.filePath);
  // }
}



/*

//code just before using provider

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:juzox_music_app/utils/permission_handler.dart';
import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';
import 'package:juzox_music_app/widgets/mini_player.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';

import 'package:just_audio/just_audio.dart';

import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/music_screen.dart';
import 'package:juzox_music_app/widgets/juzox_bottom_navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final ValueNotifier<int> _currentPageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<JuzoxMusicModel?> _currentlyPlayingSongNotifier =
      ValueNotifier<JuzoxMusicModel?>(null);

  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> _currentDurationNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> _totalDurationNotifier =
      ValueNotifier<Duration>(Duration.zero);

  //for swaping pause button when finished playing a song
  final ValueNotifier<ProcessingState> _processingStateNotifier =
      ValueNotifier<ProcessingState>(ProcessingState.idle);

  final JuzoxAudioPlayerService _juzoxAudioPlayerService =
      JuzoxAudioPlayerService();

  @override
  void initState() {
    super.initState();

    _juzoxAudioPlayerService.audioPlayer.positionStream.listen((duration) {
      _currentDurationNotifier.value = duration;
    });
    _juzoxAudioPlayerService.audioPlayer.durationStream.listen((duration) {
      _totalDurationNotifier.value = duration ?? Duration.zero;
    });
    _juzoxAudioPlayerService.audioPlayer.playingStream.listen((isPlaying) {
      _isPlayingNotifier.value = isPlaying;
    });

//for swaping pause button when finished playing a song
    _juzoxAudioPlayerService.audioPlayer.processingStateStream.listen((state) {
      _processingStateNotifier.value = state;
    });
  }

  @override
  void dispose() {
    _currentPageIndexNotifier.dispose();
    _currentlyPlayingSongNotifier.dispose();
    _isPlayingNotifier.dispose();
    _currentDurationNotifier.dispose();
    _totalDurationNotifier.dispose();
    _processingStateNotifier.dispose();
    super.dispose();
  }

  void _playSong(String url) {
    _juzoxAudioPlayerService.juzoxPlay(url);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPageIndexNotifier,
      builder: (context, currentPageIndex, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          bottomNavigationBar: JuzoxBottomNavigationBar(
            onCurrentPageChanged: (newIndex) {
              _currentPageIndexNotifier.value = newIndex;
              //   print('debug check 1 currentpageindex = $newIndex');
            },
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: currentPageIndex,
                children: [
                  const HomeScreen(),
                  MusicScreen(
                    onSongSelected: _onSongSelected,
                    isPlayingNotifier: _isPlayingNotifier,
                  ),
                  const LibraryScreen(),
                ],
              ),
              ValueListenableBuilder<JuzoxMusicModel?>(
                valueListenable: _currentlyPlayingSongNotifier,
                builder: (context, currentlyPlayingSong, child) {
                  if (currentlyPlayingSong != null) {
                    return Positioned(
                      bottom: 54, //height of bottom nav bar
                      left: 45,
                      child: MiniPlayer(
                        song: currentlyPlayingSong,
                        juzoxAudioPlayerService: _juzoxAudioPlayerService,
                        isPlaying: _isPlayingNotifier,
                        currentDuration: _currentDurationNotifier,
                        totalDuration: _totalDurationNotifier,
                        processingState: _processingStateNotifier,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSongSelected(JuzoxMusicModel song) {
    _currentlyPlayingSongNotifier.value = song;
    _playSong(song.filePath);
  }
}


*/





/*
//originals
import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/music_screen.dart';
import 'package:juzox_music_app/widgets/juzox_bottom_navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TabsScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    void handleOnCurrentPageChanged(int newIndex) {
      setState(() {
        currentPageIndex = newIndex;
      });

      print('debug check 1 currentpageindex = $currentPageIndex');
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('My Music'),
      // ),
      bottomNavigationBar: JuzoxBottomNavigationBar(
        onCurrentPageChanged: handleOnCurrentPageChanged,
      ),
      body: [
        const HomeScreen(),
        const MusicScreen(),
        const LibraryScreen(),
      ][currentPageIndex],
    );
  }
}
*/


/*
//here is the code to change it to stateless widget and use valuelistenablebuilder
//but itis actually not required here - here only the tabs index is changing in this whole and if i used value notifier , then also it needs to rebuild it when the index changes,, same is the case with set state.. so here, both of this has same effect
//Also, while using valuenotifier, we need to dispose it to avoid memory leaks, so we need to call dispose method and calling dispose method can be achievable only on stateful widget, so anyway we need stateful widget.... 
//in below code, the notifier is not disposed...
class TabsScreen extends StatelessWidget {
  TabsScreen({super.key});

  final ValueNotifier<int> currentPageIndexNotifier = ValueNotifier<int>(0);

  void handleOnCurrentPageChanged(int newIndex) {
    currentPageIndexNotifier.value = newIndex;
    print('debug check 1 currentpageindex = $newIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: JuzoxBottomNavigationBar(
        onCurrentPageChanged: handleOnCurrentPageChanged,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: currentPageIndexNotifier,
        builder: (context, currentPageIndex, child) {
          return [
            HomeScreen(),
            MusicScreen(),
            LibraryScreen(),
          ][currentPageIndex];
        },
      ),
    );
  }
}



*/