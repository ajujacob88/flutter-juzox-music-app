import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
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

    return Selector<AudioPlayerProvider, List<JuzoxMusicModel>>(
        selector: (context, audioPlayerProvider) =>
            audioPlayerProvider.favoriteSongs,
        shouldRebuild: (previous, current) {
          //The selected value must be immutable, or otherwise Selector may think nothing changed and not call builder again... so _favoriteSongs.remove(song); in audioProvider is mutable, so selector wont notify the changes and hence ui wont update.. so change it to immutable by creating new list every time like this  _favoriteSongs = List.from(_favoriteSongs)..remove(song);  To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
          debugPrint(
              "previous.length is ${previous.length} and previous is $previous");
          debugPrint(
              "current.length is  ${current.length} and current $current");
          return previous != current;
        },
        builder: (_, favoriteSongs, __) {
          return ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (_, index) {
                //  return Text(audioPlayerProvider.favoriteSongs[index].album!);
                return ListTile(
                  title: Text(favoriteSongs[index].title!),
                );
              });
        });
  }
}
