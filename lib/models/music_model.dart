class MusicModel {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String filePath;
//  final String album;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.filePath,
    //   required this.album,
  });

  // Factory constructor to create a SongModel from a SongInfo object
  factory MusicModel.fromSongInfo(songInfo) {
    return MusicModel(
      id: songInfo.id.toString(), // Convert ID to String
      title: songInfo.title,
      artist: songInfo.artist,
      duration: songInfo.duration.toString(),
      filePath: songInfo.filePath,
      //  album: songInfo.album,
    );
  }
}
