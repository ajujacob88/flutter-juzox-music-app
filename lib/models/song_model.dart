class SongModel {
//  final String id;
  final String title;
  final String artist;
  final String duration;
  final String filePath;
  final String album;

  SongModel({
    //   required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.filePath,
    required this.album,
  });

  // Factory constructor to create a SongModel from a SongInfo object
  factory SongModel.fromSongInfo(songInfo) {
    return SongModel(
      //id: songInfo.id.toString(), // Convert ID to String
      title: songInfo.title,
      artist: songInfo.artist,
      duration: songInfo.duration.toString(),
      filePath: songInfo.filePath,
      album: songInfo.album,
    );
  }
}
