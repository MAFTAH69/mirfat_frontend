import 'package:flutter/material.dart';

class LiveStream {
  final int id;
  final String url;
  final String topic;
  final String speaker;

  LiveStream({
    @required this.id,
    @required this.url,
    @required this.topic,
    @required this.speaker,
  });

  LiveStream.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['url'] != null),
        assert(map['topic'] != null),
        assert(map['speaker'] != null),
        id = map['id'],
        url = map['url'],
        topic = map['topic'],
        speaker = map['speaker'];
}
