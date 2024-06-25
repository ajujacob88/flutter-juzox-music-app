class JuzoxMusicModel {
  final int? id;
  final String? title;
  final String? artist;
  final int? duration;
  final String filePath;
  final String? album;
  final String? fileExtension;

  JuzoxMusicModel(
      {this.id,
      this.title,
      this.artist,
      this.duration,
      required this.filePath,
      this.album,
      this.fileExtension});

  // Factory constructor to create a SongModel from a SongInfo object
  factory JuzoxMusicModel.fromSongInfo(songInfo) {
    return JuzoxMusicModel(
      id: songInfo.id,
      title: songInfo.title,
      artist: songInfo.artist,
      duration: songInfo.duration,
      filePath: songInfo.data,
      album: songInfo.album,
      fileExtension: songInfo.fileExtension,
    );
  }

//for favorites song -shared preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'filepath': filePath,
      'album': album,
      'fileExtension': fileExtension,
    };
  }

  static JuzoxMusicModel fromJson(Map<String, dynamic> json) {
    return JuzoxMusicModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      filePath: json['filepath'],
      album: json['album'],
      fileExtension: json['fileExtension'],
    );
  }
}
