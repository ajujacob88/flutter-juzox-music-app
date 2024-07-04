import 'dart:ui';

import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Ensure this import is correct

class PlaylistSongsPage extends StatelessWidget {
  final String playlistName;

  const PlaylistSongsPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final bool isFavoritePlaylist = playlistName == 'Favorites';
    final List<JuzoxMusicModel> playlistSongs;

    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    if (!isFavoritePlaylist) {
      playlistSongs = audioPlayerProvider.userPlaylistSongs[playlistName] ?? [];
    } else {
      playlistSongs = audioPlayerProvider.favoriteSongs;
    }

    final favFirstSongId = audioPlayerProvider.favoriteSongs.isNotEmpty
        ? audioPlayerProvider.favoriteSongs[0].id
        : 0;
    int? lastPlayedFavoriteSong;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(playlistName),
        // ),
        body: CustomScrollView(
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

            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Selector<AudioPlayerProvider, int?>(
                    selector: (context, audioPlayerProvider) {
                      // int? lastPlayedFavoriteSong;
                      if (audioPlayerProvider.currentlyPlayingSong != null) {
                        if (audioPlayerProvider.isFavorite(
                            audioPlayerProvider.currentlyPlayingSong!)) {
                          lastPlayedFavoriteSong =
                              audioPlayerProvider.currentlyPlayingSong!.id;
                          return audioPlayerProvider.currentlyPlayingSong!.id;
                        }
                        return lastPlayedFavoriteSong;
                      }
                      return lastPlayedFavoriteSong;
                    },
                    shouldRebuild: (previous, current) => previous != current,
                    builder: (_, currentPlayingSongId, __) {
                      return QueryArtworkWidget(
                        //  id: favFirstSongId ??0,
                        id: currentPlayingSongId ?? favFirstSongId ?? 0,
                        size: 200, //500
                        quality: 40,

                        type: ArtworkType.AUDIO,
                      );
                    },
                  ),
                ),
                const Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.favorite,
                    size: 70,
                    // color: Color.fromARGB(63, 1, 61, 89),
                    color: Color.fromARGB(40, 1, 61, 89),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(122, 68, 137, 255),
                        Color.fromARGB(117, 64, 195, 255),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: Text(playlistName),
          ),
          // title: Text('Aju'),
        ),
        SliverAppBar(
          // primary: false,
          // excludeHeaderSemantics: true,
          automaticallyImplyLeading: false,
          pinned: true,
          // floating: true,
          // snap: true,
          forceElevated: true,
          elevation: 200,
          scrolledUnderElevation: 30,
          //shadowColor: Color.fromARGB(188, 6, 102, 197),
          shadowColor: const Color.fromARGB(184, 6, 82, 158),
          //backgroundColor: Colors.transparent,
          // backgroundColor: Color.fromARGB(255, 0, 17, 42),
          actions: [
            TextButton.icon(
              onPressed: () {
                if (isFavoritePlaylist) {
                  if (audioPlayerProvider.favoriteSongs.isNotEmpty) {
                    audioPlayerProvider.playSongFromList(
                        audioPlayerProvider.favoriteSongs[0],
                        audioPlayerProvider.favoriteSongs);
                  }
                } else {
                  if (audioPlayerProvider
                      .userPlaylistSongs[playlistName]!.isNotEmpty) {
                    audioPlayerProvider.playSongFromList(
                        audioPlayerProvider.userPlaylistSongs[playlistName]![0],
                        audioPlayerProvider.userPlaylistSongs[playlistName]!);
                  }
                }
              },
              icon: const Icon(
                Icons.play_circle,
                size: 32,
                color: Colors.lightBlueAccent,
              ),
              label: Selector<AudioPlayerProvider, int>(
                selector: (context, audioPlayerProvider) {
                  if (isFavoritePlaylist) {
                    return audioPlayerProvider.favoriteSongs.length;
                  } else {
                    return audioPlayerProvider
                        .userPlaylistSongs[playlistName]!.length;
                  }
                },
                shouldRebuild: (previous, current) => previous != current,
                builder: (_, favoritelength, __) {
                  return RichText(
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
                          text: '($favoritelength)',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
          selector: (context, audioPlayerProvider) {
            if (isFavoritePlaylist) {
              return audioPlayerProvider.favoriteSongs;
            } else {
              return audioPlayerProvider.userPlaylistSongs[playlistName]!;
            }
          },
          shouldRebuild: (previous, current) {
            //The selected value must be immutable, or otherwise Selector may think nothing changed and not call builder again... so _favoriteSongs.remove(song); in audioProvider is mutable, so selector wont notify the changes and hence ui wont update.. so change it to immutable by creating new list every time like this  _favoriteSongs = List.from(_favoriteSongs)..remove(song);  To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
            // debugPrint(
            //     "previous.length is ${previous.length} and previous is $previous");
            // debugPrint(
            //     "current.length is  ${current.length} and current $current");
            return previous != current;
          },
          builder: (_, playlistSongs, myChild) {
            return SliverList.builder(
              key: const PageStorageKey<String>('allfavoriteSongs'),
              itemCount: playlistSongs.length,
              itemBuilder: (_, index) {
                //  return Text(audioPlayerProvider.favoriteSongs[index].album!);
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 18, right: 4),
                  title: Text(
                    playlistSongs[index].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    '${playlistSongs[index].artist!} - ${playlistSongs[index].album}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: QueryArtworkWidget(
                    artworkBorder: const BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),
                    artworkClipBehavior: Clip.hardEdge,
                    //  controller: _audioQuery,
                    id: playlistSongs[index].id!,
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
                          return data.item1 == playlistSongs[index].id
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
                  onTap: () {
                    if (isFavoritePlaylist) {
                      return audioPlayerProvider.playSongFromList(
                          audioPlayerProvider.favoriteSongs[index],
                          audioPlayerProvider.favoriteSongs);
                    } else {
                      return audioPlayerProvider.playSongFromList(
                          audioPlayerProvider
                              .userPlaylistSongs[playlistName]![index],
                          audioPlayerProvider.userPlaylistSongs[playlistName]!);
                    }
                  },
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
    ));
  }
}

/*
//before last stash
import 'dart:ui';

import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/widgets/static_music_indicator.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Ensure this import is correct

class PlaylistSongsPage extends StatelessWidget {
  final String playlistName;

  const PlaylistSongsPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final bool isFavoritePlaylist = playlistName == 'Favorites';
    final List<JuzoxMusicModel> playlistSongs;

    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    if (!isFavoritePlaylist) {
      playlistSongs = audioPlayerProvider.userPlaylistSongs[playlistName] ?? [];
    } else {
      playlistSongs = audioPlayerProvider.favoriteSongs;
    }

    final favFirstSongId = audioPlayerProvider.favoriteSongs.isNotEmpty
        ? audioPlayerProvider.favoriteSongs[0].id
        : 0;
    int? lastPlayedFavoriteSong;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(playlistName),
        // ),
        body: CustomScrollView(
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

            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Selector<AudioPlayerProvider, int?>(
                    selector: (context, audioPlayerProvider) {
                      // int? lastPlayedFavoriteSong;
                      if (audioPlayerProvider.currentlyPlayingSong != null) {
                        if (audioPlayerProvider.isFavorite(
                            audioPlayerProvider.currentlyPlayingSong!)) {
                          lastPlayedFavoriteSong =
                              audioPlayerProvider.currentlyPlayingSong!.id;
                          return audioPlayerProvider.currentlyPlayingSong!.id;
                        }
                        return lastPlayedFavoriteSong;
                      }
                      return lastPlayedFavoriteSong;
                    },
                    shouldRebuild: (previous, current) => previous != current,
                    builder: (_, currentPlayingSongId, __) {
                      return QueryArtworkWidget(
                        //  id: favFirstSongId ??0,
                        id: currentPlayingSongId ?? favFirstSongId ?? 0,
                        size: 200, //500
                        quality: 40,

                        type: ArtworkType.AUDIO,
                      );
                    },
                  ),
                ),
                const Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.favorite,
                    size: 70,
                    // color: Color.fromARGB(63, 1, 61, 89),
                    color: Color.fromARGB(40, 1, 61, 89),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(122, 68, 137, 255),
                        Color.fromARGB(117, 64, 195, 255),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: Text(playlistName),
          ),
          // title: Text('Aju'),
        ),
        SliverAppBar(
          // primary: false,
          // excludeHeaderSemantics: true,
          automaticallyImplyLeading: false,
          pinned: true,
          // floating: true,
          // snap: true,
          forceElevated: true,
          elevation: 200,
          scrolledUnderElevation: 30,
          //shadowColor: Color.fromARGB(188, 6, 102, 197),
          shadowColor: const Color.fromARGB(184, 6, 82, 158),
          //backgroundColor: Colors.transparent,
          // backgroundColor: Color.fromARGB(255, 0, 17, 42),
          actions: [
            TextButton.icon(
              onPressed: () {
                if (isFavoritePlaylist) {
                  if (audioPlayerProvider.favoriteSongs.isNotEmpty) {
                    audioPlayerProvider.playSongFromList(
                        audioPlayerProvider.favoriteSongs[0],
                        audioPlayerProvider.favoriteSongs);
                  }
                } else {
                  if (audioPlayerProvider
                      .userPlaylistSongs[playlistName]!.isNotEmpty) {
                    audioPlayerProvider.playSongFromList(
                        audioPlayerProvider.userPlaylistSongs[playlistName]![0],
                        audioPlayerProvider.userPlaylistSongs[playlistName]!);
                  }
                }
              },
              icon: const Icon(
                Icons.play_circle,
                size: 32,
                color: Colors.lightBlueAccent,
              ),
              label: Selector<AudioPlayerProvider, int>(
                selector: (context, audioPlayerProvider) =>
                    audioPlayerProvider.favoriteSongs.length,
                shouldRebuild: (previous, current) => previous != current,
                builder: (_, favoritelength, __) {
                  return RichText(
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
                          text: '($favoritelength)',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
        Selector<
            AudioPlayerProvider,
            ({
              List<JuzoxMusicModel> favoriteSongs,
              Map<String, List<JuzoxMusicModel>> userPlaylistSongs
            })>(
          selector: (_, audioPlayerProvider) => (
            favoriteSongs: audioPlayerProvider.favoriteSongs,
            userPlaylistSongs: audioPlayerProvider.userPlaylistSongs,
          ),
          shouldRebuild: (previous, current) {
            return previous != current;
          },
          builder: (_, data, myChild) {
            return SliverList.builder(
              key: const PageStorageKey<String>('allfavoriteSongs'),
              itemCount: isFavoritePlaylist
                  ? data.favoriteSongs.length
                  : data.userPlaylistSongs.length,
              itemBuilder: (_, index) {
                //  return Text(audioPlayerProvider.favoriteSongs[index].album!);
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 18, right: 4),
                  title: Text(
                    isFavoritePlaylist
                        ? data.favoriteSongs[index].title!
                        : data.userPlaylistSongs[playlistName]![index].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    isFavoritePlaylist
                        ? '${data.favoriteSongs[index].artist!} - ${data.favoriteSongs[index].album}'
                        : '${data.userPlaylistSongs[playlistName]![index].artist!} - ${data.userPlaylistSongs[playlistName]![index].album}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: QueryArtworkWidget(
                    artworkBorder: const BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),
                    artworkClipBehavior: Clip.hardEdge,
                    //  controller: _audioQuery,
                    id: isFavoritePlaylist
                        ? data.favoriteSongs[index].id!
                        : data.userPlaylistSongs[playlistName]![index].id!,
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
                        builder: (context, playingData, child) {
                          if (isFavoritePlaylist) {
                            return playingData.item1 ==
                                    data.favoriteSongs[index].id
                                ? playingData.item2
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
                                : const StaticMusicIndicator(
                                    color: Colors.lightBlueAccent,
                                    size: 0,
                                  );
                          } else {
                            return playingData.item1 ==
                                    data.userPlaylistSongs[playlistName]![index]
                                        .id
                                ? playingData.item2
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
                                : const StaticMusicIndicator(
                                    color: Colors.lightBlueAccent,
                                    size: 0,
                                  );
                          }
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
                  onTap: () {
                    return audioPlayerProvider.playSongFromList(
                        audioPlayerProvider.favoriteSongs[index],
                        audioPlayerProvider.favoriteSongs);
                  },
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
    ));
  }
}
/*
//just before changing desing
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Ensure this import is correct

class PlaylistSongsPage extends StatelessWidget {
  final String playlistName;

  const PlaylistSongsPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final bool isFavoritePlaylist = playlistName == 'Favorites';
    final List<JuzoxMusicModel> playlistSongs;

    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    if (!isFavoritePlaylist) {
      playlistSongs = audioPlayerProvider.userPlaylistSongs[playlistName] ?? [];
    } else {
      playlistSongs = audioPlayerProvider.favoriteSongs;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: ListView.builder(
        itemCount: playlistSongs.length,
        itemBuilder: (context, index) {
          final song = playlistSongs[index];
          return ListTile(
            leading: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(8),
              artworkClipBehavior: Clip.hardEdge,
              artworkWidth: 50,
              artworkHeight: 50,
              id: song.id!,
              artworkColor: const Color.fromARGB(249, 7, 69, 116),
              artworkBlendMode: BlendMode.screen,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(22, 68, 137, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 40.0,
                height: 40.0,
                child: const Icon(
                  Icons.music_note_outlined,
                  color: Color.fromARGB(140, 64, 195, 255),
                  size: 30,
                ),
              ),
            ),
            title: Text(song.title!),
            onTap: () {
              // Implement the functionality to play the selected song
            },
          );
        },
      ),
    );
  }
}
*/
*/
/*
//just before changing desing
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Ensure this import is correct

class PlaylistSongsPage extends StatelessWidget {
  final String playlistName;

  const PlaylistSongsPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final bool isFavoritePlaylist = playlistName == 'Favorites';
    final List<JuzoxMusicModel> playlistSongs;

    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    if (!isFavoritePlaylist) {
      playlistSongs = audioPlayerProvider.userPlaylistSongs[playlistName] ?? [];
    } else {
      playlistSongs = audioPlayerProvider.favoriteSongs;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: ListView.builder(
        itemCount: playlistSongs.length,
        itemBuilder: (context, index) {
          final song = playlistSongs[index];
          return ListTile(
            leading: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(8),
              artworkClipBehavior: Clip.hardEdge,
              artworkWidth: 50,
              artworkHeight: 50,
              id: song.id!,
              artworkColor: const Color.fromARGB(249, 7, 69, 116),
              artworkBlendMode: BlendMode.screen,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(22, 68, 137, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 40.0,
                height: 40.0,
                child: const Icon(
                  Icons.music_note_outlined,
                  color: Color.fromARGB(140, 64, 195, 255),
                  size: 30,
                ),
              ),
            ),
            title: Text(song.title!),
            onTap: () {
              // Implement the functionality to play the selected song
            },
          );
        },
      ),
    );
  }
}
*/