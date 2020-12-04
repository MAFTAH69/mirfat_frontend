import 'package:flutter/material.dart';

class Video {
  final int id;
  final String date;
  final String file;

  Video({
    @required this.id,
    @required this.date,
    @required this.file,
  });

  Video.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['file'] != null),
        assert(map['date'] != null),
        id = map['id'],
        file = map['file'],
        date = map['date'];
}
