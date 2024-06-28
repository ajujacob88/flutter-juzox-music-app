import 'dart:ui';

import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab>
    with AutomaticKeepAliveClientMixin<FavoritesTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    final id = audioPlayerProvider.favoriteSongs[0].id;
    return CustomScrollView(
      key: const PageStorageKey<String>('favorites'),
      slivers: [
        SliverAppBar(
          // floating: true,
          // pinned: true,
          stretch: true,
          onStretchTrigger: () {
            // Function callback for stretch
            return Future<void>.value();
          },
          expandedHeight: 200.0,
          //expandedHeight: 150.0,
          //  backgroundColor: Colors.transparent,
          //  title: const Text('Favorite Songs'),

          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            centerTitle: true,
            //  expandedTitleScale: 1.2,
            expandedTitleScale: 1.5,

            // background: QueryArtworkWidget(
            //   id: id!,
            //   size: 400, //500
            //   quality: 80,

            //   type: ArtworkType.AUDIO,
            // ),
            //  background: ColoredBox(color: Color.fromARGB(65, 1, 19, 33)),

            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: QueryArtworkWidget(
                    id: id!,
                    size: 400, //500
                    quality: 80,

                    type: ArtworkType.AUDIO,
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      //begin: Alignment(0.0, 0.5),
                      //end: Alignment.center,
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(122, 68, 137, 255),
                        Color.fromARGB(117, 64, 195, 255),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: const Text('Favorite Songs'),
          ),
          // title: Text('Aju'),
        ),
        SliverAppBar(
          pinned: true,
          // floating: true,
          // snap: true,
          forceElevated: true,
          elevation: 200,
          scrolledUnderElevation: 30,
          //shadowColor: Color.fromARGB(188, 6, 102, 197),
          shadowColor: Color.fromARGB(184, 6, 82, 158),
          //backgroundColor: Colors.transparent,
          // backgroundColor: Color.fromARGB(255, 0, 17, 42),
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.play_circle,
                size: 32,
                color: Colors.lightBlueAccent,
              ),
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Play all  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '(ch)',
                      style: TextStyle(
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
              onPressed: () {},
            ),
            DropdownButton<String>(
              items: [],
              onChanged: (value) {},
              icon: const Icon(
                CupertinoIcons.arrow_up_arrow_down,
                color: Colors.white70,
                size: 20,
              ),
            ),
            IconButton(
              iconSize: 20,
              color: Colors.white70,
              icon: const Icon(Icons.checklist),
              onPressed: () {},
            ),
          ],
        ),
        Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
          selector: (context, audioPlayerProvider) =>
              audioPlayerProvider.favoriteSongs,
          shouldRebuild: (previous, current) {
            //The selected value must be immutable, or otherwise Selector may think nothing changed and not call builder again... so _favoriteSongs.remove(song); in audioProvider is mutable, so selector wont notify the changes and hence ui wont update.. so change it to immutable by creating new list every time like this  _favoriteSongs = List.from(_favoriteSongs)..remove(song);  To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
            // debugPrint(
            //     "previous.length is ${previous.length} and previous is $previous");
            // debugPrint(
            //     "current.length is  ${current.length} and current $current");
            return previous != current;
          },
          builder: (_, favoriteSongs, myChild) {
            return SliverList.builder(
              key: const PageStorageKey<String>('allfavoriteSongs'),
              itemCount: favoriteSongs.length,
              itemBuilder: (_, index) {
                //  return Text(audioPlayerProvider.favoriteSongs[index].album!);
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 18, right: 4),
                  title: Text(
                    favoriteSongs[index].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    '${favoriteSongs[index].artist!} - ${favoriteSongs[index].album}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: QueryArtworkWidget(
                    artworkBorder: const BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),
                    artworkClipBehavior: Clip.hardEdge,
                    //  controller: _audioQuery,
                    id: favoriteSongs[index].id!,
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Selector<AudioPlayerProvider, ({int? item1, bool item2})>(
                        selector: (context, audioplayerprovider) => (
                          item1: audioplayerprovider.currentlyPlayingSong?.id,
                          item2: audioplayerprovider.isPlaying
                        ),
                        builder: (context, data, child) {
                          return data.item1 == favoriteSongs[index].id
                              ? data.item2
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
                                    )
                              // : const AnimatedMusicIndicator(
                              //     animate: false,
                              //     size: .06,
                              //   );
                              : const StaticMusicIndicator(
                                  color: Colors.lightBlueAccent,
                                  size: 0,
                                );
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.more_vert),
                      //   color: const Color.fromARGB(130, 255, 255, 255),
                      //   onPressed: () {
                      //     // Add logic to handle settings button tap
                      //   },
                      // ),
                      //by using child in builder, this mychild wont rebuild if this selector builder function executes
                      myChild!
                    ],
                  ),
                );
              },
            );
          },
          //by using child in builder, this mychild wont rebuild if this selector builder function executes
          child: IconButton(
            icon: const Icon(Icons.more_vert),
            color: const Color.fromARGB(130, 255, 255, 255),
            onPressed: () {
              // Add logic to handle settings button tap
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 190,
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Text(
                    'This much Favorites',
                  ),
                )),
          ),
        ),
      ],
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

  // @override
  // Widget build(
  //     BuildContext context, double shrinkOffset, bool overlapsContent) {
  //   return child;
  // }

  // @override
  // bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
  //   return false;
  // }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}


/*
// learning child/ mychild in selector builder
import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab>
    with AutomaticKeepAliveClientMixin<FavoritesTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); //to preserve the state AutomaticKeepAliveClientMixin
    // final audioPlayerProvider =
    //     Provider.of<AudioPlayerProvider>(context, listen: false);

    return CustomScrollView(
      key: const PageStorageKey<String>('favorites'),
      slivers: [
        Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
          selector: (context, audioPlayerProvider) =>
              audioPlayerProvider.favoriteSongs,
          shouldRebuild: (previous, current) {
            //The selected value must be immutable, or otherwise Selector may think nothing changed and not call builder again... so _favoriteSongs.remove(song); in audioProvider is mutable, so selector wont notify the changes and hence ui wont update.. so change it to immutable by creating new list every time like this  _favoriteSongs = List.from(_favoriteSongs)..remove(song);  To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
            // debugPrint(
            //     "previous.length is ${previous.length} and previous is $previous");
            // debugPrint(
            //     "current.length is  ${current.length} and current $current");
            return previous != current;
          },
          builder: (_, favoriteSongs, myChild) {
            myChild = myChild;
            return SliverList.builder(
              key: const PageStorageKey<String>('allfavoriteSongs'),
              itemCount: favoriteSongs.length,
              itemBuilder: (_, index) {
                //  return Text(audioPlayerProvider.favoriteSongs[index].album!);
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 18, right: 4),
                  title: Text(
                    favoriteSongs[index].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    '${favoriteSongs[index].artist!} - ${favoriteSongs[index].album}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: QueryArtworkWidget(
                    artworkBorder: const BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),
                    artworkClipBehavior: Clip.hardEdge,
                    //  controller: _audioQuery,
                    id: favoriteSongs[index].id!,
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Selector<AudioPlayerProvider, ({int? item1, bool item2})>(
                        selector: (context, audioplayerprovider) => (
                          item1: audioplayerprovider.currentlyPlayingSong?.id,
                          item2: audioplayerprovider.isPlaying
                        ),
                        builder: (context, data, child) {
                          return data.item1 == favoriteSongs[index].id
                              ? data.item2
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
                                    )
                              // : const AnimatedMusicIndicator(
                              //     animate: false,
                              //     size: .06,
                              //   );
                              : const StaticMusicIndicator(
                                  color: Colors.lightBlueAccent,
                                  size: 0,
                                );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        color: const Color.fromARGB(130, 255, 255, 255),
                        onPressed: () {
                          // Add logic to handle settings button tap
                        },
                      ),
                      // myChild!,
                      // Text(
                      //   'Finished ${favoriteSongs.length}',
                      // ),
                      // Text('${DateTime.now()}')
                      myChild!
                    ],
                  ),
                );
              },
            );
          },

          child: Text('${DateTime.now()}'),
          // child: MaterialButton(
          //   child: Text("Do some action"),
          //   onPressed: () {},
          // )
          // child: SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 190,
          //     child: Align(
          //         alignment: Alignment.center,
          //         child: Padding(
          //           padding: const EdgeInsets.only(bottom: 100),
          //           child: Text(
          //             'Finished ${audioPlayerProvider.currentlyPlayingSong?.title ?? 'no song playing'}',
          //           ),
          //         )),
          //   ),
          // ),

          // child: Text(
          //   'Finished ${audioPlayerProvider.currentlyPlayingSong?.title ?? 'no song playing'}',
          // ),

          //  child: Text(
          //               'Finished ${favoriteSongs.length}',
          //             ),
        ),
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 190,
        //     child: Align(
        //         alignment: Alignment.center,
        //         child: Padding(
        //           padding: const EdgeInsets.only(bottom: 100),
        //           child: Text(
        //             'This much Favorites ${audioPlayerProvider.currentlyPlayingSong?.title ?? 'NO SONG playing'}',
        //           ),
        //         )),
        //   ),
        // ),
      ],
    );
  }
}
*/