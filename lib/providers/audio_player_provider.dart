import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final JuzoxAudioPlayerService _juzoxAudioPlayerService =
      JuzoxAudioPlayerService();

  JuzoxMusicModel? _currentlyPlayingSong;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //for swaping pause button when finished playing a song
  ProcessingState _processingState = ProcessingState.idle;
  // List<String> _userPlaylists = ['Favoritess'];
  List<String> _userPlaylists = [];

  Map<String, List<JuzoxMusicModel>> _userplaylistSongs = {};

  // int? _prevIndex;

  List<JuzoxMusicModel> _playlist = [];
//  List<JuzoxMusicModel> _defaultSongs = [];

  List<JuzoxMusicModel> _favoriteSongs = [];

  List<JuzoxMusicModel> _allSongs = [];

  AudioPlayerProvider() {
    _juzoxAudioPlayerService.audioPlayer.positionStream.listen((duration) {
      _currentDuration = duration;
      notifyListeners();
    });
    _juzoxAudioPlayerService.audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });
    _juzoxAudioPlayerService.audioPlayer.playingStream.listen((isPlaying) {
      _isPlaying = isPlaying;
      notifyListeners();
    });

//for swaping pause button when finished playing a song
    _juzoxAudioPlayerService.audioPlayer.processingStateStream.listen((state) {
      _processingState = state;
      notifyListeners();

      if (state == ProcessingState.completed) {
        playNextSong();
      }
    });

    // Ensure "Favorites" is always included
    if (!_userPlaylists.contains('Favorites')) {
      _userPlaylists.insert(0, 'Favorites');
    }

    // Load favorite songs when the provider is initialized
    _loadFavoriteSongs();
    _loadUserPlaylists();
  }

  JuzoxMusicModel? get currentlyPlayingSong => _currentlyPlayingSong;

  // JuzoxMusicModel? get currentlyPlayingSong {
  //   return _currentlyPlayingSong;
  // }

  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  ProcessingState get processingState => _processingState;

  JuzoxAudioPlayerService get juzoxAudioPlayerService =>
      _juzoxAudioPlayerService;

  List<JuzoxMusicModel> get favoriteSongs => _favoriteSongs;

  List<String> get userPlaylists => _userPlaylists;

  List<JuzoxMusicModel> get allSongs => _allSongs;

  Map<String, List<JuzoxMusicModel>> get userPlaylistSongs =>
      _userplaylistSongs;

  void setCurrentlyPlayingSong(JuzoxMusicModel song) {
    _currentlyPlayingSong = song;
    // playSong(song.filePath);
    _juzoxAudioPlayerService.juzoxPlay(song.filePath);
    notifyListeners();
  }

  void setPlaylist(List<JuzoxMusicModel> playlist) {
    _playlist = playlist;
  }

//to play previous song
  void playPreviousSong() {
    if (_currentlyPlayingSong == null || _playlist.isEmpty) return;

    final prevSong = previousSong;
    if (prevSong != null) {
      setCurrentlyPlayingSong(prevSong);
    }
  }

  JuzoxMusicModel? get previousSong {
    if (_currentlyPlayingSong != null) {
      final currentIndex = _playlist.indexOf(_currentlyPlayingSong!);
      final prevIndex =
          (currentIndex - 1 + _playlist.length) % _playlist.length;

      return _playlist[prevIndex];
    }
    return null;
  }

//to play next song
  void playNextSong() {
    if (_currentlyPlayingSong == null || _playlist.isEmpty) return;

    final nexSong = nextSong;
    if (nexSong != null) {
      setCurrentlyPlayingSong(nexSong);
    }
  }

  JuzoxMusicModel? get nextSong {
    if (_currentlyPlayingSong != null) {
      final currentIndex = _playlist.indexOf(_currentlyPlayingSong!);
      final nextIndex = (currentIndex + 1) % _playlist.length;
      return _playlist[nextIndex];
    }
    return null;
  }

//play song from a playlist/favorite/all song
  void playSongFromList(JuzoxMusicModel song, List<JuzoxMusicModel> playlist) {
    setPlaylist(playlist);
    setCurrentlyPlayingSong(song);
  }

  //for favorites
  void addSongToFavorites(JuzoxMusicModel song) {
    // if (!_favoriteSongs.contains(song)) {
    // _favoriteSongs.add(song);

    // if (!_favoriteSongs.any((favoriteSong) => favoriteSong.id == song.id)) {
    //To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
    _favoriteSongs = List.from(_favoriteSongs)..add(song);
    // //or
    // _favoriteSongs = List.of(_favoriteSongs)..add(song);

    _saveFavoriteSongs();
    notifyListeners();
    // }
  }

  void removeSongFromFavorites(JuzoxMusicModel song) {
    // if (_favoriteSongs.contains(song)) {
    //   // _favoriteSongs.remove(song);

    // if (_favoriteSongs.any((favoriteSong) => favoriteSong.id == song.id)) {
    //_favoriteSongs = List.from(_favoriteSongs)..remove(song);
    // //or
    // _favoriteSongs = List.of(_favoriteSongs)..remove(song);

    _favoriteSongs = List.from(_favoriteSongs)
      ..removeWhere((element) => element.id == song.id);
    _saveFavoriteSongs();
    notifyListeners();
    // }
  }

  bool isFavorite(JuzoxMusicModel song) {
    //contains wont work, since it check all the values and the hashcode of both values will be different and hence always return false
    // return _favoriteSongs.contains(song);
    return _favoriteSongs.any((favoriteSong) {
      //  debugPrint(
      //      'decoded encoded data - element is ${favoriteSong.id} -  curr pl song - ${song.id}');
      return favoriteSong.id == song.id;
    });
  }

  //directly write the function here to call it from songs page favorite button
  void toggleFavoriteStatusOfSong(JuzoxMusicModel song) {
    !isFavorite(song)
        ? addSongToFavorites(song)
        : removeSongFromFavorites(song);
  }

  // void addMultipleSongsToFavorite(List<JuzoxMusicModel> songs){}

  // Save favorite songs to shared preferences
  Future<void> _saveFavoriteSongs() async {
    try {
      debugPrint('encoded data debugg check1');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _favoriteSongs.map((song) => song.toJson()).toList(),
      );
      /*
      //this is the same one written above
      final String encodedData2 = jsonEncode(
        _favoriteSongs.map(
          (song) {
            return song.toJson();
          },
        ).toList(),
      );
    */
      debugPrint('encoded data is $encodedData');
      await prefs.setString('favoriteSongs', encodedData);
    } catch (error) {
      debugPrint('Failed to save favorite songs: $error');
    }
  }

  // Load favorite songs from shared preferences
  Future<void> _loadFavoriteSongs() async {
    try {
      debugPrint('decoded encoded data debug check1');
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('favoriteSongs');
      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        _favoriteSongs = decodedData
            .map((json) => JuzoxMusicModel.fromJson(json))
            .toList()
            .cast<JuzoxMusicModel>();
        /*      
      //same as above
      _favoriteSongs = decodedData.map(
        (json) {
          return JuzoxMusicModel.fromJson(json);
        },
      ).toList().cast<JuzoxMusicModel>();
      */
        notifyListeners();
        debugPrint('decoded encoded data is $decodedData');
      }
    } catch (error) {
      debugPrint('Failed to load favorite songs: $error');
    }
  }

  void addMultipleSongsToFavorite(List<JuzoxMusicModel> songs) {
    // if (_userplaylistSongs.containsKey(playlistName)) {

    //   _userplaylistSongs =
    //       Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs)
    //         ..[playlistName] = List.from(songs);

    _favoriteSongs = List.from(songs);

    _saveFavoriteSongs();
    notifyListeners();
    //}
  }

  void addUserPlaylist(String playlistName) {
    if (!_userPlaylists.contains(playlistName)) {
      // _userPlaylists.add(playlistName);
      _userPlaylists = List.from(_userPlaylists)..add(playlistName);
      _userplaylistSongs[playlistName] = [];
      _saveUserPlaylists();
      notifyListeners();
    }
  }

  // Method to delete a playlist
  void deleteUserPlaylist(String playlistName) {
    // _userPlaylists.remove(playlistName);
    _userPlaylists = List.from(_userPlaylists)..remove(playlistName);
    _userplaylistSongs.remove(playlistName);
    _saveUserPlaylists();
    notifyListeners();
  }

/*
  Future<void> _saveUserPlaylists() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('userPlaylists', _userPlaylists);
    } catch (error) {
      debugPrint('Failed to save user playlists: $error');
    }
  }

  Future<void> _loadUserPlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? loadedPlaylists =
          prefs.getStringList('userPlaylists');
      if (loadedPlaylists != null) {
        _userPlaylists = loadedPlaylists;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Failed to load user playlists: $error');
    }
  }
*/
  void addSongsToPlaylist(String playlistName, List<JuzoxMusicModel> songs) {
    if (_userplaylistSongs.containsKey(playlistName)) {
      //_userplaylistSongs[playlistName]!.addAll(songs);

      // _userplaylistSongs[playlistName] =
      //     List.from(_userplaylistSongs[playlistName]!)..addAll(songs);

      // Create a new list for the specific playlist inorder to solve the problem of immutability in selector
      // final updatedPlaylistSongs =
      //     List<JuzoxMusicModel>.from(_userplaylistSongs[playlistName]!)
      //       ..addAll(songs);

      // above causes the already added songs to add again, so this is enough
      //  final updatedPlaylistSongs = songs;

/*
      //anothe method using set
      final existingSongs = _userplaylistSongs[playlistName] ?? [];

      // Create a set of song IDs to quickly check for duplicates
      final existingSongIds = existingSongs.map((song) => song.id).toSet();

      // Filter out songs that are already in the playlist
      final newSongs =
          songs.where((song) => !existingSongIds.contains(song.id)).toList();

      // Create the updated playlist by adding new songs to the existing ones
      final updatedPlaylistSongs = List<JuzoxMusicModel>.from(existingSongs)
        ..addAll(newSongs);
*/
      // Create a new map and update the specific playlist with the new list
      // _userplaylistSongs =
      //     Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs)
      //       ..[playlistName] = updatedPlaylistSongs;

      // _userplaylistSongs =
      //     Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs)
      //       ..[playlistName] = songs;

      _userplaylistSongs =
          Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs)
            ..[playlistName] = List.from(songs);

      _saveUserPlaylists();
      notifyListeners();
    }
  }

  // void addSongsToPlaylist(String playlistName, JuzoxMusicModel song) {
  //   _playlistSongs[playlistName]?.add(song);
  //   _saveUserPlaylists();
  //   notifyListeners();
  // }

  Future<void> _saveUserPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedPlaylists = jsonEncode(_userPlaylists);

    // final String encodedPlaylistSongs = jsonEncode(_userplaylistSongs.map(
    //     (key, value) =>
    //         MapEntry(key, value.map((song) => song.toJson()).toList())));

    final String encodedPlaylistSongs = jsonEncode(
      _userplaylistSongs.map(
        (key, value) => MapEntry(
          key,
          value.map((song) {
            debugPrint(
                'saveuserplaylist inside map key is $key and value is $value');
            return song.toJson();
          }).toList(),
        ),
      ),
    );

    debugPrint(
        'saveuserplaylist encodedplaylist $encodedPlaylists and songs $encodedPlaylistSongs');

    await prefs.setString('userPlaylists', encodedPlaylists);
    await prefs.setString('playlistSongs', encodedPlaylistSongs);
  }

  Future<void> _loadUserPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedPlaylists = prefs.getString('userPlaylists');
    final String? encodedPlaylistSongs = prefs.getString('playlistSongs');

    debugPrint(
        'saveuserplaylist initially $encodedPlaylists and songs $encodedPlaylistSongs');
    if (encodedPlaylists != null) {
      _userPlaylists = List<String>.from(jsonDecode(encodedPlaylists));
      debugPrint('saveuserplaylist first if $_userPlaylists');
    }

    if (encodedPlaylistSongs != null) {
      final Map<String, dynamic> decodedPlaylistSongs =
          jsonDecode(encodedPlaylistSongs);
      _userplaylistSongs = decodedPlaylistSongs
          .map<String, List<JuzoxMusicModel>>((key, value) => MapEntry(
              key,
              List<JuzoxMusicModel>.from(
                  value.map((item) => JuzoxMusicModel.fromJson(item)))));

      debugPrint('saveuserplaylist second if $_userplaylistSongs ');
    }

    debugPrint(
        'saveuserplaylist initially2 $encodedPlaylists and songs $encodedPlaylistSongs');

    debugPrint(
        'saveuserplaylist decodedplaylist $_userPlaylists and songs $_userplaylistSongs');
    notifyListeners();
  }

  // Method to rename a playlist
  void renamePlaylist(String oldName, String newName) {
    if (_userPlaylists.contains(oldName)) {
      final int index = _userPlaylists.indexOf(oldName);
      // _userPlaylists[index] = newName;

// Create a new list with the updated playlist name
      _userPlaylists = List.from(_userPlaylists)..[index] = newName;

      final List<JuzoxMusicModel>? songs = _userplaylistSongs.remove(oldName);
      if (songs != null) {
        _userplaylistSongs[newName] = songs;
      }

      _saveUserPlaylists();
      notifyListeners();
    }
  }

//to store all songs initially from the songs tab while loading the app
  void saveAllSongs(List<JuzoxMusicModel> allSongs) {
    _allSongs = allSongs;
    notifyListeners();
  }

  // Shuffle songs in a specific playlist
  void shufflePlaylistSongs(String playlistName) {
    // final playlistSongs = userPlaylistSongs[playlistName];
    // List<JuzoxMusicModel>? playlistSongs = userPlaylistSongs[playlistName];
    // if (playlistSongs != null && playlistSongs.isNotEmpty) {
    //   playlistSongs.shuffle(Random());
    // playlistSongs = List<JuzoxMusicModel>.from(playlistSongs)
    //   ..shuffle(Random());

    // userPlaylistSongs[playlistName]!.shuffle(Random());

    // _userplaylistSongs =
    //     Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs)
    //       ..[playlistName]!.shuffle(Random());
    //userPlaylistSongs[playlistName]?.shuffle();
    //notifyListeners();

    // final newPlaylistSongs =
    //     Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs);
    // newPlaylistSongs[playlistName]?.shuffle(Random());
    // _userplaylistSongs = newPlaylistSongs;
    // notifyListeners();

//To ensure the Selector properly detects changes and triggers a rebuild, modify shufflePlaylistSongs to create a completely new map with shuffled songs:
    //debugPrint('checkingggg 1 $playlistName');
    if (playlistName == 'allSongs') {
      // debugPrint('checkingggg 4');
      final List<JuzoxMusicModel> shuffledSongs =
          List<JuzoxMusicModel>.from(_allSongs);
      shuffledSongs.shuffle(Random());
      _allSongs = shuffledSongs;
      notifyListeners();
    } else if (playlistName != 'Favorites') {
      if (_userplaylistSongs.containsKey(playlistName)) {
        // debugPrint('checkingggg 2');
        final List<JuzoxMusicModel> shuffledSongs =
            List.from(_userplaylistSongs[playlistName]!);
        shuffledSongs.shuffle(Random());
        final newPlaylistSongs =
            Map<String, List<JuzoxMusicModel>>.from(_userplaylistSongs);
        newPlaylistSongs[playlistName] = shuffledSongs;
        _userplaylistSongs = newPlaylistSongs;
        notifyListeners();
      }
    } else if (playlistName == 'Favorites') {
      // debugPrint('checkingggg 3');
      final List<JuzoxMusicModel> shuffledSongs =
          List<JuzoxMusicModel>.from(_favoriteSongs);
      shuffledSongs.shuffle(Random());
      _favoriteSongs = shuffledSongs;
      notifyListeners();
    }
  }
}
