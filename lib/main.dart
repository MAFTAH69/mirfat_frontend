import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mirfat_frontend/home.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:mirfat_frontend/providers/data_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DataProvider _dataProvider = DataProvider();

  @override
  void initState() {

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    _dataProvider.getAllStreams();
    _dataProvider.getAllPictures();
    _dataProvider.getAllVideos();
    super.initState();
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _dataProvider),
        ],
        child: MaterialApp(
            title: 'Safhatussaalihiin',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.brown,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Home()));
  }
}
