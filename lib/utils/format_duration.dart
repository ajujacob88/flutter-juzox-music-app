//utils fuction created to format the duration in mm:ss format

String formatDuration(double durationInSeconds) {
  int minutes = (durationInSeconds / 60).floor();
  int seconds = (durationInSeconds % 60).floor();
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
