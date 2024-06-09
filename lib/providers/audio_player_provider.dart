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

  List<JuzoxMusicModel> _playlist = [];
  List<JuzoxMusicModel> _defaultSongs = [];

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
        _playNextSong();
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

  // void playSong(String url) {
  //   _juzoxAudioPlayerService.juzoxPlay(url);
  // }

  void setCurrentlyPlayingSong(JuzoxMusicModel song) {
    _currentlyPlayingSong = song;
    // playSong(song.filePath);
    _juzoxAudioPlayerService.juzoxPlay(song.filePath);
    notifyListeners();
  }

  void setPlaylist(List<JuzoxMusicModel> playlist) {
    _playlist = playlist;
  }

  void _playNextSong() {
    if (_currentlyPlayingSong != null) {
      // final currentIndex = _playlist.isNotEmpty
      //     ? _playlist.indexOf(_currentlyPlayingSong!)
      //     : _defaultSongs.indexOf(_currentlyPlayingSong!);
      // final nextIndex = (currentIndex + 1) %
      //     (_playlist.isNotEmpty ? _playlist.length : _defaultSongs.length);
      // setCurrentlyPlayingSong(_playlist.isNotEmpty
      //     ? _playlist[nextIndex]
      //     : _defaultSongs[nextIndex]);

      final currentIndex = _playlist.indexOf(_currentlyPlayingSong!);
      final nextIndex = (currentIndex + 1) % _playlist.length;
      setCurrentlyPlayingSong(_playlist[nextIndex]);
    }
  }

  // Optional: Method to add default songs
  void setDefaultSongs(List<JuzoxMusicModel> songs) {
    _defaultSongs = songs;
  }

  void playSongFromList(JuzoxMusicModel song, List<JuzoxMusicModel> playlist) {
    setPlaylist(playlist);
    setCurrentlyPlayingSong(song);
  }
}
