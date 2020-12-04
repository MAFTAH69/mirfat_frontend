import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mirfat_frontend/providers/data_provider.dart';
import 'package:provider/provider.dart';

enum PlayerState { playing, stopped }

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  void initState() {
    audioStart();
    super.initState();
  }

  @override
  void dispose() {
    FlutterRadio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _streamObject = Provider.of<DataProvider>(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/back.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Colors.amber[50].withOpacity(0.7), BlendMode.lighten),
      )),
      child: Expanded(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.brown[200],
              radius: 120,
              child: Icon(
                FontAwesomeIcons.microphone,
                size: 130,
                color: Colors.brown[900],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _streamObject.streams .isEmpty
                ? Center(
                    child: Text(""),
                  )
                : Container(
              margin: EdgeInsets.only(left: 100, right: 100),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15)),
              child: isPlaying
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(
                        Icons.stop,
                        size: 60,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FlutterRadio.stop();
                        setState(() {
                          playerState = PlayerState.stopped;
                        });
                      })
                  : FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(
                        Icons.play_arrow,
                        size: 60,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FlutterRadio.play(url: _streamObject.streams[0].url);
                        setState(() {
                          playerState = PlayerState.playing;
                        });
                      }),
            ),
            SizedBox(
              height: 20,
            ),
           _streamObject.streams .isEmpty
                ? Center(
                    child: Text("'Afwan! Hatupo live mdaa huu.",textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ): Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _streamObject.streams[0].speaker,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )),
           _streamObject.streams .isEmpty
                ? Center(
                    child: Text(""),
                  )
                : Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_streamObject.streams[0].topic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  )),
            )),
          ],
        ),
      ),
    );
  }
}
