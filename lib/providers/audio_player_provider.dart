import 'dart:convert';

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

  // int? _prevIndex;

  List<JuzoxMusicModel> _playlist = [];
//  List<JuzoxMusicModel> _defaultSongs = [];

  List<JuzoxMusicModel> _favoriteSongs = [];

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

    // Load favorite songs when the provider is initialized
    _loadFavoriteSongs();
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
    if (!_favoriteSongs.contains(song)) {
      // _favoriteSongs.add(song);

      //To ensure Selector works correctly, the list itself should be treated immutably. Instead of modifying the existing list, create a new list each time an item is added or removed. This way, the Selector can detect the change properly.
      _favoriteSongs = List.from(_favoriteSongs)..add(song);
      // //or
      // _favoriteSongs = List.of(_favoriteSongs)..add(song);

      _saveFavoriteSongs();
      notifyListeners();
    }
  }

  void removeSongFromFavorites(JuzoxMusicModel song) {
    if (_favoriteSongs.contains(song)) {
      // _favoriteSongs.remove(song);
      _favoriteSongs = List.from(_favoriteSongs)..remove(song);
      // //or
      // _favoriteSongs = List.of(_favoriteSongs)..remove(song);

      _saveFavoriteSongs();
      notifyListeners();
    }
  }

  bool isFavorite(JuzoxMusicModel song) {
    return _favoriteSongs.contains(song);
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
}
