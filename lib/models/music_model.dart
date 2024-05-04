class MusicModel {
  final int? id;
  final String? title;
  final String? artist;
  final int? duration;
  final String filePath;
  final String? album;
  final String? fileExtension;

  MusicModel(
      {this.id,
      this.title,
      this.artist,
      this.duration,
      required this.filePath,
      this.album,
      this.fileExtension});

  // Factory constructor to create a SongModel from a SongInfo object
  factory MusicModel.fromSongInfo(songInfo) {
    return MusicModel(
      id: songInfo.id,
      title: songInfo.title,
      artist: songInfo.artist,
      duration: songInfo.duration,
      filePath: songInfo.data,
      album: songInfo.album,
      fileExtension: songInfo.fileExtension,
    );
  }
}
