import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:juzox_music_app/models/music_model.dart';
import 'package:juzox_music_app/services/audio_player_service.dart';

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
      _favoriteSongs.add(song);
      notifyListeners();
    }
  }

  void removeSongFromFavorites(JuzoxMusicModel song) {
    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song);
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
}
