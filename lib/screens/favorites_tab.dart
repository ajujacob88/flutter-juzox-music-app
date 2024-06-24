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
        shouldRebuild: (previous, current) => previous != current,
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
