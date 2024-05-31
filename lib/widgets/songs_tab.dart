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

class SongsTab extends StatefulWidget {
  const SongsTab({super.key});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab>
    with AutomaticKeepAliveClientMixin<SongsTab> {
  //AutomaticKeepAliveClientMixin: This mixin helps maintain the state of the "Songs" tab when switching tabs. Without it, the ListView might rebuild from scratch each time the tab is revisited, losing the scroll position.

  final OnAudioQuery _audioQuery = OnAudioQuery();

  final JuzoxAudioPlayerService _juzoxAudioPlayerService =
      JuzoxAudioPlayerService();

  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

  JuzoxMusicModel? _currentlyPlayingSong;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  final ValueNotifier<Duration> currentDuration = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> totalDuration = ValueNotifier(Duration.zero);
  final ValueNotifier<ProcessingState> processingState =
      ValueNotifier(ProcessingState.idle);

  @override
  bool get wantKeepAlive => true;
  //to preserve the state AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
    // Request storage permission on initialization
    requestStoragePermission().then((granted) {
      if (granted) {
        getAudioFiles(); // Call function to get audio files on permission grant
      }
    });

    _juzoxAudioPlayerService.audioPlayer.positionStream.listen((duration) {
      currentDuration.value = duration;
    });
    _juzoxAudioPlayerService.audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
    _juzoxAudioPlayerService.audioPlayer.playingStream.listen((isPlaying) {
      this.isPlaying.value = isPlaying;
    });

//for swaping pause button when finished playing a song
    _juzoxAudioPlayerService.audioPlayer.processingStateStream.listen((state) {
      processingState.value = state;
    });
  }

//dispose check once again because the miniplayer is needed for other pages also, so this dispose should be removed and use REMOVE instead(check a screenshot),,
  @override
  void dispose() {
    _juzoxAudioPlayerService.dispose();

    // Dispose the ValueNotifiers when the widget is disposed
    currentDuration.dispose();
    totalDuration.dispose();
    isPlaying.dispose();
    processingState.dispose();

    super.dispose();
  }

  Future<void> getAudioFiles() async {
    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    //    print('song data is ${songs[0].data} andddd song uri is ${songs[0].uri}');

    _songs = songs
        .where((songInfo) =>
            songInfo.fileExtension == 'mp3' || songInfo.fileExtension == 'm4a')
        .map((songInfo) => JuzoxMusicModel.fromSongInfo(songInfo))
        .toList();

    setState(() {});
    //print('songs is ${_songs[3]}');
  }

  void _playSong(String url) {
    _juzoxAudioPlayerService.juzoxPlay(url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin

    return Stack(
      children: [
        Container(
          color: const Color.fromARGB(0, 0, 0, 0),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Your onPressed logic here
                },
                icon: const Icon(
                  Icons.play_circle,
                  size: 32,
                  color: Colors.lightBlueAccent,
                ),
                label: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Play all  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '(${_songs.length})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              IconButton(
                iconSize: 20,
                color: Colors.white70,
                padding: const EdgeInsets.only(right: 8),
                icon: const Icon(CupertinoIcons.shuffle),
                onPressed: () {
                  // Add logic for song selection (optional)
                },
              ),
              // Sort button
              DropdownButton<String>(
                items: [],
                // value:
                //     _selectedSortOption, // Store selected sort option state
                // items: _sortOptions.map((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),
                onChanged: (value) {
                  setState(() {
                    //      _selectedSortOption = value!;
                    // Update song list based on selected sort option (replace with logic)
                  });
                },

                //  padding: EdgeInsets.only(right: 2),

                icon: const Icon(
                  CupertinoIcons.arrow_up_arrow_down,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
              // Selection button (optional) - Implement based on your needs
              IconButton(
                iconSize: 20,
                color: Colors.white70,
                icon: const Icon(Icons.checklist),
                onPressed: () {
                  // Add logic for song selection (optional)
                },
              ),
            ],
          ),
        ),
        RefreshIndicator(
          color: Colors.blueAccent,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            getAudioFiles();
          },
          child: Positioned(
            top: 50,
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomScrollView(
              key: const PageStorageKey<String>('songssss'),
              //above key is to preserve the state while scrolling,, that is for scroll position preservation.
              slivers: [
                SliverList.builder(
                  key: const PageStorageKey<String>('allSongs'),
                  //PageStorageKey: Using PageStorageKey(key: 'allSongs') on the ListView.builder helps Flutter associate the list with a unique identifier. This allows it to restore the scroll position when the "Songs" tab is re-rendered. //to preserve the state AutomaticKeepAliveClientMixin ... allSongs can be any unique string
                  //                physics: const AlwaysScrollableScrollPhysics(),

                  //       physics: const AlwaysScrollableScrollPhysics(),
                  //This forces scrolling even when the content of the scrollable widget’s content doesn’t exceed the height of the screen, so even when scrolling is not needed.You might need it when you want to use a RefreshIndicator widget, this widget will not show unless it’s content is scrollable, but if you have content that doesn’t exceed the height of the screen but you want to wrap it with a RefreshIndicator widget, you’ll definitely need to use the AlwaysScrollableScrollPhysics.

                  // physics: const BouncingScrollPhysics(
                  //   parent: AlwaysScrollableScrollPhysics(),
                  // ),

                  // physics: const ClampingScrollPhysics(
                  //     parent: AlwaysScrollableScrollPhysics()),

                  //  physics: NeverScrollableScrollPhysics(),

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
                      leading: QueryArtworkWidget(
                        artworkBorder: const BorderRadius.horizontal(
                            left: Radius.circular(8),
                            right: Radius.circular(8)),
                        artworkClipBehavior: Clip.hardEdge,
                        controller: _audioQuery,
                        id: song.id!,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(22, 68, 137, 255),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                  right: Radius.circular(8))),
                          // Set desired width and height for the box
                          width: 50.0, // Adjust as needed
                          height: 50.0, // Adjust as needed

                          child: const Icon(
                            Icons.music_note_outlined,
                            color: Color.fromARGB(140, 64, 195, 255),
                            size: 30,
                          ),
                        ),
                      ),

                      trailing: _tappedSongId == song.id
                          ? Row(
                              //  crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: isPlaying,
                                  builder: (context, isPlayingValue, child) {
                                    return isPlayingValue
                                        ? const AnimatedMusicIndicator(
                                            color: Colors.lightBlueAccent,
                                            barStyle: BarStyle.solid,
                                            size: .06,
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(top: 18.0),
                                            child: StaticMusicIndicator(
                                              color: Colors.lightBlueAccent,
                                              size: .1,
                                            ),
                                          ); //
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  color:
                                      const Color.fromARGB(130, 255, 255, 255),
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
                                  size: .06,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  color:
                                      const Color.fromARGB(130, 255, 255, 255),
                                  onPressed: () {
                                    // Add logic to handle settings button tap
                                  },
                                ),
                              ],
                            ),

                      onTap: () {
                        _playSong(song.filePath);
                        setState(() {
                          _tappedSongId = song.id;
                          _currentlyPlayingSong = song;
                        });
                      },
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 190,
                    child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 100),
                          child: Text(
                            'Finished',
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_currentlyPlayingSong != null)
          Positioned(
            bottom: 54, //height of bottom nav bar
            left: 45,

            child: MiniPlayer(
              song: _currentlyPlayingSong!,
              juzoxAudioPlayerService: _juzoxAudioPlayerService,
              isPlaying: isPlaying,
              currentDuration: currentDuration,
              totalDuration: totalDuration,
              processingState: processingState,
            ),
          ),
        // CupertinoSlider(
        //   value: 10,
        //   max: 30,
        //   onChanged: (value) {},
        // ),
      ],
    );
  }
}
