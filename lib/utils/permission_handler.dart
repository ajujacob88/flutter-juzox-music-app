import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  // <!-- Android 12 or below  --> need to check the os condition and the version here
  //if (Platform.isAndroid)
  final storageStatus = await Permission.storage.request();

  // <!-- applicable for Android 13 or greater  -->
  final audiosPermission = await Permission.audio.request();
  final photosPermission = await Permission.photos.request();
  final videosPermission = await Permission.videos.request();

  print(
      'debug storagepermission this stor $storageStatus, audio $audiosPermission, pho $photosPermission, vid $videosPermission');
  return ((storageStatus == PermissionStatus.granted) ||
      ((audiosPermission == PermissionStatus.granted) &&
          (photosPermission == PermissionStatus.granted) &&
          (videosPermission == PermissionStatus.granted)));
}
