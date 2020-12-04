import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mirfat_frontend/api.dart';
import 'package:http/http.dart' as http;
import 'package:mirfat_frontend/main.dart';
import 'package:mirfat_frontend/models/LiveStream.dart';
import 'package:mirfat_frontend/models/Picture.dart';
import 'package:mirfat_frontend/models/Video.dart';
import 'dart:ui';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DataProvider extends ChangeNotifier {
// ********** STREAMS DATA ***********
  List<LiveStream> _streams = [];

  List<LiveStream> get streams => _streams;

  Future<void> getAllStreams() async {
    List<LiveStream> _fetchedStreams = [];
    try {
      http.Response response = await http.get(api + 'streams');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['streams'].forEach(($stream) {
          final streamDataSet = LiveStream.fromMap($stream);
          _fetchedStreams.add(streamDataSet);
        });
        _streams = _fetchedStreams;
        print(_fetchedStreams);
        print(_fetchedStreams.length);
      }
    } catch (e) {
      print("Stream fetching failed");
      print(e);
    }
  }

// ********** PICTURES DATA ***********
  List<Picture> _pictures = [];

  List<Picture> get pictures => _pictures;

  Future<void> getAllPictures() async {
    List<Picture> _fetchedPictures = [];
    try {
      http.Response response = await http.get(api + 'pictures');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['pictures'].forEach(($picture) {
          final pictureDataSet = Picture.fromMap($picture);
          _fetchedPictures.add(pictureDataSet);
        });
        _pictures = _fetchedPictures;
        print(_fetchedPictures);
        print(_fetchedPictures.length);
      }
    } catch (e) {
      print("Picture fetching failed");
      print(e);
    }
    notifyListeners();
  }

// ********** VIDEOS DATA ***********
  List<Video> _videos = [];

  List<Video> get videos => _videos;

  Future<void> getAllVideos() async {
    List<Video> _fetchedVideos = [];
    try {
      http.Response response = await http.get(api + 'videos');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['videos'].forEach(($video) {
          final videoDataSet = Video.fromMap($video);
          _fetchedVideos.add(videoDataSet);
        });

        _videos = _fetchedVideos;
        print(_fetchedVideos);
        print(_fetchedVideos.length);
      }
    } catch (e) {
      print("Videos fetching failed");
      print(e);
    }
    notifyListeners();
  }

// *
// *
// *
// *
// *
// *
// *
// *
// *
// *
// *
// *

// DOWNLOAD MANAGER

  final Dio _dio = Dio();
  String url = "";
  String title = "";
  String progress = "";
  int newPictureIndex;
  int newVideoIndex;

  Future<void> downloadCard() async {
    Directory downloadsDirectory = await getExternalStorageDirectory();
    downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final savePath = path.join(downloadsDirectory.path + "/" + title);

    await _startDownload(savePath);
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    await _showDownloadNotification(progress);
    try {
      final response = await _dio.download(url, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      // progress = "";
      notifyListeners();
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      progress = (received / total * 100).toStringAsFixed(0) + "%";
      notifyListeners();
    }
  }

  Future<void> cancelDownload() async {
    _dio.delete(url);
  }

  // *

  // NOTIFICATION MANAGER

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        icon: '@mipmap/safhatussaalihiin',
        priority: Priority.High,
        importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Maa shaa Allah' : "'Afwan !",
        isSuccess
            ? 'Umefanikiwa kupakua kadi hii.'
            : 'Imeshindikana kupakuwa kadi hii.',
        platform,
        payload: json);
  }

  Future<void> _showDownloadNotification(dPrg) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        icon: '@mipmap/safhatussaalihiin',
        priority: Priority.High,
        importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.show(
      1, // notification id
      "Downloading ...",
      progress,
      platform,
    );
  }
}
