import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:io';
import 'package:animated_music_indicator/animated_music_indicator.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with AutomaticKeepAliveClientMixin<MusicScreen> {
  //AutomaticKeepAliveClientMixin: This mixin helps maintain the state of the "Songs" tab when switching tabs. Without it, the ListView might rebuild from scratch each time the tab is revisited, losing the scroll position.
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

  @override
  bool get wantKeepAlive =>
      true; //to preserve the state AutomaticKeepAliveClientMixin

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
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    // Get the width of the screen
    //final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding as a percentage of the screen width
    // final double leftPadding = screenWidth * 0.05; // 5% of screen width
    // final double rightPadding = screenWidth * 0.01; // 1% of screen width

    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          onlyOneScrollInBody: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                    context),
                sliver: SliverAppBar(
                  //backgroundColor: Color.fromARGB(30, 6, 1, 27),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: !innerBoxIsScrolled
                  //     ? Colors.transparent
                  //     : Color.fromARGB(255, 5, 37, 73),

                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  scrolledUnderElevation: 0, //while scrolling opacitty 0 to 1

                  // title: AppBar(
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  //   titleSpacing: 0,
                  actions: [
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
                        padding: EdgeInsets.only(right: 18, left: 18),
                        child: Icon(
                          Icons.menu_outlined,
                          size: 30,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],

                  //    ),
                  bottom: const TabBar(
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    // padding: EdgeInsets.only(left: 0),
                    indicatorColor: Colors.lightBlueAccent,
                    // indicatorSize: TabBarIndicatorSize.label,
                    //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                    labelColor: Colors.lightBlueAccent,
                    labelStyle: TextStyle(fontSize: 17),
                    unselectedLabelColor: Color.fromARGB(159, 255, 255, 255),
                    unselectedLabelStyle: TextStyle(fontSize: 15),
                    //unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,

                    tabAlignment: TabAlignment.start,

                    tabs: [
                      Tab(text: 'Favorites'),
                      Tab(text: 'Songs'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Folders'),
                      Tab(text: 'Albums'),
                      Tab(text: 'Artiists'),
                      Tab(text: 'Genres'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            minimum: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kTextTabBarHeight),

            // minimum:
            //     EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight - 15),
            child: TabBarView(
              children: [
                const Text('Favorites'),

                Column(
                  children: [
                    Container(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // Your onPressed logic here
                            },
                            // style: TextButton.styleFrom(
                            //   textStyle: const TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            icon: const Icon(
                              Icons.play_circle,
                              size: 36,
                              color: Colors.lightBlueAccent,
                            ),
                            label: Text(
                              'Play all(${_songs.length})',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
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
                          ),
                          // Selection button (optional) - Implement based on your needs
                          IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              // Add logic for song selection (optional)
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: Colors.blueAccent,
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          getAudioFiles();
                        },
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 18, right: 4),

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
                                    // artworkBorder: BorderRadius.only(
                                    //   topLeft: Radius.circular(8),
                                    //   topRight: Radius.circular(8),
                                    //   bottomLeft: Radius.circular(8),
                                    //   bottomRight: Radius.circular(8),
                                    // ),

                                    artworkBorder:
                                        const BorderRadius.horizontal(
                                            left: Radius.circular(8),
                                            right: Radius.circular(8)),

                                    artworkClipBehavior: Clip.hardEdge,

                                    //   artworkClipBehavior: Clip.none,
                                    controller: _audioQuery,
                                    id: song.id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(22, 68, 137, 255),
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(8),
                                              right: Radius.circular(8))),
                                      // Set desired width and height for the box
                                      width: 50.0, // Adjust as needed
                                      height: 50.0, // Adjust as needed
                                      // color: const Color.fromARGB(22, 4, 190, 94),
                                      // color: const Color.fromARGB(22, 68, 137, 255), //this
                                      //color: const Color.fromARGB(22, 64, 195, 255),
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        //  color: Color.fromARGB(185, 4, 190, 94),
                                        //  color: Colors.lightBlueAccent,
                                        color:
                                            Color.fromARGB(140, 64, 195, 255),
                                        size: 30,
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
                                              color: const Color.fromARGB(
                                                  130, 255, 255, 255),
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
                                              color: Color.fromARGB(
                                                  130, 255, 255, 255),
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
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Text('Playlists'),
                // const Text('Folders'),
                const SampleFolderView(),

                // const Text('Albums')
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (context, index) =>
                //     const SliverToBoxAdapter(
                //       child: Text('Albums'),
                //     ),
                //   ),
                // ),

                CustomScrollView(
                  key: const PageStorageKey('Sample1Key'),
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Text('.alb.  $index');
                        },
                        childCount: 40,
                        semanticIndexOffset: 2,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text('Albums'),
                    ),
                  ],
                ),

                const Text('Artists'),
                //  const Text('Genre'),
                const SampleListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SampleFolderView extends StatefulWidget {
  const SampleFolderView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleFolderViewState();
}

class _SampleFolderViewState extends State<SampleFolderView>
    with AutomaticKeepAliveClientMixin<SampleFolderView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('SampleKeyy22'),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text('.folder.  $index');
            },
            childCount: 40,
            semanticIndexOffset: 2,
          ),
        ),
        const SliverToBoxAdapter(
          child: Text('Folders'),
        ),
      ],
    );
  }
}

class SampleListView extends StatefulWidget {
  const SampleListView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleListViewState();
}

class _SampleListViewState extends State<SampleListView>
    with AutomaticKeepAliveClientMixin<SampleListView> {
//  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     print('my position is ${_scrollController.position}');
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey('SampleListKey'),
        //    controller: _scrollController,
        itemCount: 200,
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(
            i.toString(),
            // textScaleFactor: 1.5,
            style: TextStyle(color: Colors.blue),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //    _scrollController.animateTo(
          //        _scrollController.position.minScrollExtent,
          //       duration: const Duration(seconds: 2),
          //       curve: Curves.easeIn);
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}



/*
//code which changed sliverappbar to container inside tabbar view - worked fine


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:io';
import 'package:animated_music_indicator/animated_music_indicator.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with AutomaticKeepAliveClientMixin<MusicScreen> {
  //AutomaticKeepAliveClientMixin: This mixin helps maintain the state of the "Songs" tab when switching tabs. Without it, the ListView might rebuild from scratch each time the tab is revisited, losing the scroll position.
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

  @override
  bool get wantKeepAlive =>
      true; //to preserve the state AutomaticKeepAliveClientMixin

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
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    // Get the width of the screen
    //final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding as a percentage of the screen width
    // final double leftPadding = screenWidth * 0.05; // 5% of screen width
    // final double rightPadding = screenWidth * 0.01; // 1% of screen width

    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          onlyOneScrollInBody: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                    context),
                sliver: SliverAppBar(
                  //backgroundColor: Color.fromARGB(30, 6, 1, 27),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: !innerBoxIsScrolled
                  //     ? Colors.transparent
                  //     : Color.fromARGB(255, 5, 37, 73),

                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  scrolledUnderElevation: 0, //while scrolling opacitty 0 to 1

                  // title: AppBar(
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  //   titleSpacing: 0,
                  actions: [
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
                        padding: EdgeInsets.only(right: 18, left: 18),
                        child: Icon(
                          Icons.menu_outlined,
                          size: 30,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],

                  //    ),
                  bottom: const TabBar(
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    // padding: EdgeInsets.only(left: 0),
                    indicatorColor: Colors.lightBlueAccent,
                    // indicatorSize: TabBarIndicatorSize.label,
                    //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                    labelColor: Colors.lightBlueAccent,
                    labelStyle: TextStyle(fontSize: 17),
                    unselectedLabelColor: Color.fromARGB(159, 255, 255, 255),
                    unselectedLabelStyle: TextStyle(fontSize: 15),
                    //unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,

                    tabAlignment: TabAlignment.start,

                    tabs: [
                      Tab(text: 'Favorites'),
                      Tab(text: 'Songs'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Folders'),
                      Tab(text: 'Albums'),
                      Tab(text: 'Artiists'),
                      Tab(text: 'Genres'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            minimum: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kTextTabBarHeight),

            // minimum:
            //     EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight - 15),
            child: TabBarView(
              children: [
                const Text('Favorites'),
                Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 50,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to play all songs
                            },
                            child: const Text('Play All'),
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
                          ),
                          // Selection button (optional) - Implement based on your needs
                          IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              // Add logic for song selection (optional)
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        key: const PageStorageKey<String>('songssss'),
                        //above key is to preserve the state while scrolling,, that is for scroll position preservation.
                        slivers: [
                          SliverPersistentHeader(
                            floating: true,
                            pinned: true,
                            delegate: _SliverAppBarDelegate(
                              minHeight: 60.0,
                              maxHeight: 160.0,
                              child: Container(
                                  color: Color.fromARGB(88, 199, 77, 77),
                                  child: Center(child: Text('headerTitle'))),
                            ),
                          ),
                          SliverAppBar(
                            backgroundColor: Color.fromARGB(125, 4, 11, 92),
                            pinned: true,
                            floating: true,
                            //   forceElevated: innerBoxIsScrolled,
                            scrolledUnderElevation: 0,
                            // actions: Row(
                            //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            actions: [
                              // Play all button
                              ElevatedButton(
                                onPressed: () {
                                  // Add logic to play all songs
                                },
                                child: const Text('Play All'),
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
                              ),
                              // Selection button (optional) - Implement based on your needs
                              IconButton(
                                icon: const Icon(Icons.check_box_outline_blank),
                                onPressed: () {
                                  // Add logic for song selection (optional)
                                },
                              ),
                            ],
                            // ),
                          ),
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
                                contentPadding:
                                    const EdgeInsets.only(left: 18, right: 4),

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
                                  // artworkBorder: BorderRadius.only(
                                  //   topLeft: Radius.circular(8),
                                  //   topRight: Radius.circular(8),
                                  //   bottomLeft: Radius.circular(8),
                                  //   bottomRight: Radius.circular(8),
                                  // ),

                                  artworkBorder: const BorderRadius.horizontal(
                                      left: Radius.circular(8),
                                      right: Radius.circular(8)),

                                  artworkClipBehavior: Clip.hardEdge,

                                  //   artworkClipBehavior: Clip.none,
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
                                    // color: const Color.fromARGB(22, 4, 190, 94),
                                    // color: const Color.fromARGB(22, 68, 137, 255), //this
                                    //color: const Color.fromARGB(22, 64, 195, 255),
                                    child: const Icon(
                                      Icons.music_note_outlined,
                                      //  color: Color.fromARGB(185, 4, 190, 94),
                                      //  color: Colors.lightBlueAccent,
                                      color: Color.fromARGB(140, 64, 195, 255),
                                      size: 30,
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
                                            color: const Color.fromARGB(
                                                130, 255, 255, 255),
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
                                            color: Color.fromARGB(
                                                130, 255, 255, 255),
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text('Playlists'),
                // const Text('Folders'),
                const SampleFolderView(),

                // const Text('Albums')
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (context, index) =>
                //     const SliverToBoxAdapter(
                //       child: Text('Albums'),
                //     ),
                //   ),
                // ),

                CustomScrollView(
                  key: const PageStorageKey('Sample1Key'),
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Text('.alb.  $index');
                        },
                        childCount: 40,
                        semanticIndexOffset: 2,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text('Albums'),
                    ),
                  ],
                ),

                const Text('Artists'),
                //  const Text('Genre'),
                const SampleListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SampleFolderView extends StatefulWidget {
  const SampleFolderView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleFolderViewState();
}

class _SampleFolderViewState extends State<SampleFolderView>
    with AutomaticKeepAliveClientMixin<SampleFolderView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('SampleKeyy22'),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text('.folder.  $index');
            },
            childCount: 40,
            semanticIndexOffset: 2,
          ),
        ),
        const SliverToBoxAdapter(
          child: Text('Folders'),
        ),
      ],
    );
  }
}

class SampleListView extends StatefulWidget {
  const SampleListView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleListViewState();
}

class _SampleListViewState extends State<SampleListView>
    with AutomaticKeepAliveClientMixin<SampleListView> {
//  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     print('my position is ${_scrollController.position}');
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey('SampleListKey'),
        //    controller: _scrollController,
        itemCount: 200,
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(
            i.toString(),
            // textScaleFactor: 1.5,
            style: TextStyle(color: Colors.blue),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //    _scrollController.animateTo(
          //        _scrollController.position.minScrollExtent,
          //       duration: const Duration(seconds: 2),
          //       curve: Curves.easeIn);
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
    // return Container(
    //   color: const Color.fromARGB(105, 76, 175, 79),
    // );
  }

  // @override
  // Widget build(
  //   BuildContext context,
  //   double shrinkOffset,
  //   bool overlapsContent,
  // ) {
  //   return SizedBox.expand(
  //     child: Container(
  //       color: overlapsContent
  //           ? const Color.fromARGB(112, 244, 67, 54)
  //           : const Color.fromARGB(126, 3, 168, 244),
  //       child: child,
  //     ),
  //   );
  // }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}




*/





/*
// code with PageStorage widget to preserve scrolling state between pages

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:io';
import 'package:animated_music_indicator/animated_music_indicator.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

final kbucketGlobal2 = PageStorageBucket();

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with AutomaticKeepAliveClientMixin<MusicScreen> {
  //AutomaticKeepAliveClientMixin: This mixin helps maintain the state of the "Songs" tab when switching tabs. Without it, the ListView might rebuild from scratch each time the tab is revisited, losing the scroll position.
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

  @override
  bool get wantKeepAlive =>
      true; //to preserve the state AutomaticKeepAliveClientMixin

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
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    // Get the width of the screen
    //final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding as a percentage of the screen width
    // final double leftPadding = screenWidth * 0.05; // 5% of screen width
    // final double rightPadding = screenWidth * 0.01; // 1% of screen width

    return DefaultTabController(
      // initialIndex: 1,
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          //  key: const PageStorageKey('extendednestedkey'),
          onlyOneScrollInBody: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                    context),
                sliver: SliverAppBar(
                  //backgroundColor: Color.fromARGB(30, 6, 1, 27),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: !innerBoxIsScrolled
                  //     ? Colors.transparent
                  //     : Color.fromARGB(255, 5, 37, 73),

                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  scrolledUnderElevation: 0, //while scrolling opacitty 0 to 1

                  // title: AppBar(
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  //   titleSpacing: 0,
                  actions: [
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
                        padding: EdgeInsets.only(right: 18, left: 18),
                        child: Icon(
                          Icons.menu_outlined,
                          size: 30,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],

                  //    ),
                  bottom: const TabBar(
                    //    key: PageStorageKey('tabbarkey'),
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    // padding: EdgeInsets.only(left: 0),
                    indicatorColor: Colors.lightBlueAccent,
                    // indicatorSize: TabBarIndicatorSize.label,
                    //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                    labelColor: Colors.lightBlueAccent,
                    labelStyle: TextStyle(fontSize: 17),
                    unselectedLabelColor: Color.fromARGB(159, 255, 255, 255),
                    unselectedLabelStyle: TextStyle(fontSize: 15),
                    //unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,

                    tabAlignment: TabAlignment.start,

                    tabs: [
                      Tab(text: 'Favorites'),
                      Tab(text: 'Songs'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Folders'),
                      Tab(text: 'Albums'),
                      Tab(text: 'Artiists'),
                      Tab(text: 'Genres'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            minimum: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kTextTabBarHeight),

            // minimum:
            //     EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight - 15),
            child: TabBarView(
              children: [
                //  const Text('Favorites'),
                const SampleFavView(),
                RefreshIndicator(
                  color: Colors.blueAccent,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    getAudioFiles();
                  },
                  child: CustomScrollView(
                    // key: const PageStorageKey<String>('songsList'),
                    //above key is to preserve the state while scrolling,, that is for scroll position preservation.
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Color.fromARGB(255, 4, 11, 92),
                        pinned: true,
                        floating: true,
                        //   forceElevated: innerBoxIsScrolled,
                        scrolledUnderElevation: 0,
                        // actions: Row(
                        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          // Play all button
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to play all songs
                            },
                            child: const Text('Play All'),
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
                          ),
                          // Selection button (optional) - Implement based on your needs
                          IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              // Add logic for song selection (optional)
                            },
                          ),
                        ],
                        // ),
                      ),
                      SliverList.builder(
                        //     key: const PageStorageKey<String>('allSongs'),
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
                            contentPadding:
                                const EdgeInsets.only(left: 18, right: 4),

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
                              // artworkBorder: BorderRadius.only(
                              //   topLeft: Radius.circular(8),
                              //   topRight: Radius.circular(8),
                              //   bottomLeft: Radius.circular(8),
                              //   bottomRight: Radius.circular(8),
                              // ),

                              artworkBorder: const BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                  right: Radius.circular(8)),

                              artworkClipBehavior: Clip.hardEdge,

                              //   artworkClipBehavior: Clip.none,
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
                                // color: const Color.fromARGB(22, 4, 190, 94),
                                // color: const Color.fromARGB(22, 68, 137, 255), //this
                                //color: const Color.fromARGB(22, 64, 195, 255),
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  //  color: Color.fromARGB(185, 4, 190, 94),
                                  //  color: Colors.lightBlueAccent,
                                  color: Color.fromARGB(140, 64, 195, 255),
                                  size: 30,
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
                                        color: const Color.fromARGB(
                                            130, 255, 255, 255),
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
                                        color:
                                            Color.fromARGB(130, 255, 255, 255),
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
                        },
                      ),
                    ],
                  ),
                ),
                const Text('Playlists'),

                // const Text('Folders'),
                const SampleFolderView(),

                // const Text('Albums')
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (context, index) =>
                //     const SliverToBoxAdapter(
                //       child: Text('Albums'),
                //     ),
                //   ),
                // ),

                CustomScrollView(
                  key: const PageStorageKey('Sample1Key'),
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Text('.alb.  $index');
                        },
                        childCount: 40,
                        semanticIndexOffset: 2,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text('Albums'),
                    ),
                  ],
                ),

                const Text('Artists'),
                //  const Text('Genre'),
                const SampleListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SampleFolderView extends StatefulWidget {
  const SampleFolderView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleFolderViewState();
}

class _SampleFolderViewState extends State<SampleFolderView>
    with AutomaticKeepAliveClientMixin<SampleFolderView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('SampleKeyy22'),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text('.folder.  $index');
            },
            childCount: 40,
            semanticIndexOffset: 2,
          ),
        ),
        const SliverToBoxAdapter(
          child: Text('Folders'),
        ),
      ],
    );
  }
}

class SampleFavView extends StatefulWidget {
  const SampleFavView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleFavViewState();
}

class _SampleFavViewState extends State<SampleFavView>
    with AutomaticKeepAliveClientMixin<SampleFavView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('SampleFavKeyy22'),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text('.Favorite.  $index');
            },
            childCount: 40,
            semanticIndexOffset: 2,
          ),
        ),
        const SliverToBoxAdapter(
          child: Text('Favorites'),
        ),
      ],
    );
  }
}

class SampleListView extends StatefulWidget {
  const SampleListView({super.key});
  @override
  State<StatefulWidget> createState() => _SampleListViewState();
}

class _SampleListViewState extends State<SampleListView>
    with AutomaticKeepAliveClientMixin<SampleListView> {
//  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     print('my position is ${_scrollController.position}');
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey('SampleListKey'),
        //    controller: _scrollController,
        itemCount: 200,
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(
            i.toString(),
            // textScaleFactor: 1.5,
            style: TextStyle(color: Colors.blue),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //    _scrollController.animateTo(
          //        _scrollController.position.minScrollExtent,
          //       duration: const Duration(seconds: 2),
          //       curve: Curves.easeIn);
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}







*/

/*
//code with slivercontroller and other sample tabs


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  //AutomaticKeepAliveClientMixin: This mixin helps maintain the state of the "Songs" tab when switching tabs. Without it, the ListView might rebuild from scratch each time the tab is revisited, losing the scroll position.
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];

  int? _tappedSongId;

//  final _scrollController = ScrollController();

  //@override
  // bool get wantKeepAlive => true;
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
    // super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    // Get the width of the screen
    //final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding as a percentage of the screen width
    // final double leftPadding = screenWidth * 0.05; // 5% of screen width
    // final double rightPadding = screenWidth * 0.01; // 1% of screen width

    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          //    controller: _scrollController,
          //  key: const PageStorageKey<String>('songssss222'),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  //backgroundColor: Color.fromARGB(30, 6, 1, 27),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: !innerBoxIsScrolled
                  //     ? Colors.transparent
                  //     : Color.fromARGB(255, 5, 37, 73),

                  pinned: true,
                  floating: true,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,

                  scrolledUnderElevation: 0, //while scrolling opacitty 0 to 1

                  // title: AppBar(
                  //   backgroundColor: Colors.transparent,
                  //   elevation: 0,
                  //   titleSpacing: 0,

                  actions: [
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
                        padding: EdgeInsets.only(right: 18, left: 18),
                        child: Icon(
                          Icons.menu_outlined,
                          size: 30,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],

                  //    ),

                  bottom: const TabBar(
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    // padding: EdgeInsets.only(left: 0),
                    indicatorColor: Colors.lightBlueAccent,
                    // indicatorSize: TabBarIndicatorSize.label,
                    //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                    labelColor: Colors.lightBlueAccent,
                    labelStyle: TextStyle(fontSize: 17),
                    unselectedLabelColor: Color.fromARGB(159, 255, 255, 255),
                    unselectedLabelStyle: TextStyle(fontSize: 15),
                    //unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,

                    tabAlignment: TabAlignment.start,

                    tabs: [
                      Tab(text: 'Favorites'),
                      Tab(text: 'Songs'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Folders'),
                      Tab(text: 'Albums'),
                      Tab(text: 'Artiists'),
                      Tab(text: 'Genres'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            minimum: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kTextTabBarHeight),

            // minimum:
            //     EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight - 15),
            child: TabBarView(
              //     key: const PageStorageKey<String>('songssss22'),
              children: [
                const Text('Favorites'),
                RefreshIndicator(
                  color: Colors.blueAccent,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    getAudioFiles();
                  },
                  child: CustomScrollView(
                    //   key: const PageStorageKey<String>('songssss'),

                    //above key is to preserve the state while scrolling,, that is for scroll position preservation.
                    //     controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Color.fromARGB(255, 4, 11, 92),
                        //  backgroundColor: Colors.transparent,
                        pinned: true,
                        floating: true,
                        snap: true,
                        //   forceElevated: innerBoxIsScrolled,
                        scrolledUnderElevation: 0,
                        // actions: Row(
                        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          // Play all button
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to play all songs
                            },
                            child: const Text('Play All'),
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
                          ),
                          // Selection button (optional) - Implement based on your needs
                          IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              // Add logic for song selection (optional)
                            },
                          ),
                        ],
                        // ),
                      ),

                      SliverList(
                        //   key: const PageStorageKey<String>('allSongs'),

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

                        //  itemCount: _songs.length,
                        delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                          addSemanticIndexes: true,
                          (context, index) {
                            final song = _songs[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 18, right: 4),

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
                                // artworkBorder: BorderRadius.only(
                                //   topLeft: Radius.circular(8),
                                //   topRight: Radius.circular(8),
                                //   bottomLeft: Radius.circular(8),
                                //   bottomRight: Radius.circular(8),
                                // ),

                                artworkBorder: const BorderRadius.horizontal(
                                    left: Radius.circular(8),
                                    right: Radius.circular(8)),

                                artworkClipBehavior: Clip.hardEdge,

                                //   artworkClipBehavior: Clip.none,
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
                                  // color: const Color.fromARGB(22, 4, 190, 94),
                                  // color: const Color.fromARGB(22, 68, 137, 255), //this
                                  //color: const Color.fromARGB(22, 64, 195, 255),
                                  child: const Icon(
                                    Icons.music_note_outlined,
                                    //  color: Color.fromARGB(185, 4, 190, 94),
                                    //  color: Colors.lightBlueAccent,
                                    color: Color.fromARGB(140, 64, 195, 255),
                                    size: 30,
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
                                          color: const Color.fromARGB(
                                              130, 255, 255, 255),
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
                                          color: Color.fromARGB(
                                              130, 255, 255, 255),
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
                          },
                          childCount: _songs.length,
                        ),
                      ),
                      // SliverGrid(
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 1),
                      //   delegate: SliverChildBuilderDelegate(
                      //     (BuildContext context, int index) {
                      //       return const Text('.ffff.');
                      //     },
                      //     childCount: 1,
                      //     semanticIndexOffset: 1,
                      //   ),
                      // ),
                      // SliverToBoxAdapter(child: Text('AJU')),
                    ],
                  ),
                ),
                const Text('Playlists'),
                const Text('Folders'),
                //  const Text('Albums'),
                OurSongs(),
                const Text('Artists'),
                //  const Text('Genre'),
                GetListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GetListView extends StatefulWidget {
  const GetListView({super.key});
  @override
  State<StatefulWidget> createState() => _GetListViewState();
}

class _GetListViewState extends State<GetListView> {
//  var _scrollController = ScrollController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print('my position is ${_scrollController.position}');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  super.build(context);
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 200,
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(
            i.toString(),
            // textScaleFactor: 1.5,
            style: TextStyle(color: Colors.blue),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(seconds: 2),
              curve: Curves.easeIn);
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}

class OurSongs extends StatefulWidget {
  const OurSongs({super.key});
  @override
  State<OurSongs> createState() => _OurSongsState();
}

class _OurSongsState extends State<OurSongs>
    with AutomaticKeepAliveClientMixin<OurSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<JuzoxMusicModel> _songs = [];
  // var _scrollController = ScrollController();

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //_scrollController = ScrollController(initialScrollOffset: 50.0);
  //   if (_scrollController.hasClients) _scrollController.jumpTo(50.0);
  // }

  int? _tappedSongId;
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
    super.build(context);
    return RefreshIndicator(
      color: Colors.blueAccent,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        getAudioFiles();
      },
      child: CustomScrollView(
        // controller: _controller,

        key: const PageStorageKey<String>('songssss'),

        //above key is to preserve the state while scrolling,, that is for scroll position preservation.
        //  controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 4, 11, 92),
            //  backgroundColor: Colors.transparent,
            pinned: true,
            floating: true,
            snap: true,
            //   forceElevated: innerBoxIsScrolled,
            scrolledUnderElevation: 0,
            // actions: Row(
            //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              // Play all button
              ElevatedButton(
                onPressed: () {
                  // Add logic to play all songs
                },
                child: const Text('Play All'),
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
              ),
              // Selection button (optional) - Implement based on your needs
              IconButton(
                icon: const Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  // Add logic for song selection (optional)
                },
              ),
            ],
            // ),
          ),

          SliverList(
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

            //  itemCount: _songs.length,
            delegate: SliverChildBuilderDelegate(
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              addSemanticIndexes: true,
              (context, index) {
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
                    // artworkBorder: BorderRadius.only(
                    //   topLeft: Radius.circular(8),
                    //   topRight: Radius.circular(8),
                    //   bottomLeft: Radius.circular(8),
                    //   bottomRight: Radius.circular(8),
                    // ),

                    artworkBorder: const BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),

                    artworkClipBehavior: Clip.hardEdge,

                    //   artworkClipBehavior: Clip.none,
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
                      // color: const Color.fromARGB(22, 4, 190, 94),
                      // color: const Color.fromARGB(22, 68, 137, 255), //this
                      //color: const Color.fromARGB(22, 64, 195, 255),
                      child: const Icon(
                        Icons.music_note_outlined,
                        //  color: Color.fromARGB(185, 4, 190, 94),
                        //  color: Colors.lightBlueAccent,
                        color: Color.fromARGB(140, 64, 195, 255),
                        size: 30,
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
              },
              childCount: _songs.length,
            ),
          ),
          // SliverGrid(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 1),
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return const Text('.ffff.');
          //     },
          //     childCount: 1,
          //     semanticIndexOffset: 1,
          //   ),
          // ),
          // SliverToBoxAdapter(child: Text('AJU')),
        ],
      ),
    );
  }
}


*/
