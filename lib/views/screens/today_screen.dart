import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mirfat_frontend/api.dart';
import 'package:mirfat_frontend/providers/data_provider.dart';
import 'package:provider/provider.dart';
// import 'package:videos_player/model/video.model.dart';
// import 'package:videos_player/videos_player.dart';

class TodayScreen extends StatefulWidget {
  final DataProvider dataObject;

  const TodayScreen({Key key, @required this.dataObject}) : super(key: key);
  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  DateTime _todayDate = DateTime.now();

  String todayDateMiylad = '';
  String todayDateHijr = '';
  String dayName = '';
  String hijrMonthName = '';
  String locale = 'ar';
  // String url;

  void initState() {
    // BetterPlayer.network(url);

    // GETTING TODAY'S MIYLAD DATES
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate =
        ", ${dateParse.day}/${dateParse.month}/${dateParse.year}";
    setState(() {
      todayDateMiylad = formattedDate.toString();
      dateParse.weekday == 1
          ? dayName = "Jumatatu"
          : dateParse.weekday == 2
              ? dayName = "Jumanne"
              : dateParse.weekday == 3
                  ? dayName = "Jumatano"
                  : dateParse.weekday == 4
                      ? dayName = "Alhamis"
                      : dateParse.weekday == 5
                          ? dayName = "Ijumaa"
                          : dateParse.weekday == 6
                              ? dayName = "Jumamosi"
                              : dayName = "Jumapili";
    });

    // GETTING TODAY'S HIJR DATES
    HijriCalendar.setLocal(locale);

    var _format = new HijriCalendar.now();

    var currentDate = "${_format.fullDate()}";

    setState(() {
      todayDateHijr = currentDate.toString();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/back.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Colors.amber[50].withOpacity(0.7), BlendMode.lighten),
      )),
      child: Column(
        children: [
          Container(
            height: 45,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            width: MediaQuery.of(context).size.width,
            child: Text(
              dayName + todayDateMiylad + " M = " + " " + todayDateHijr,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return _dataObject.pictures[index].date ==
                          "${_todayDate.toLocal()}".split(' ')[0]
                      ? Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
                          child: Container(
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.grey[300],
                                  elevation: 8,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Image(
                                          image: NetworkImageWithRetry(api +
                                              "picture/file/" +
                                              _dataObject.pictures[index].id
                                                  .toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.brown,
                                        height: 1.5,
                                      ),
                                      Container(
                                        child: FlatButton.icon(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            onPressed: () {
                                              setState(() {
                                                _dataObject.url = api +
                                                    "picture/file/" +
                                                    _dataObject
                                                        .pictures[index].id
                                                        .toString();

                                                _dataObject.title =
                                                    '$index. Safhatussaalihiin_' +
                                                        _dataObject
                                                            .pictures[index]
                                                            .date +
                                                        '.png';
                                              });
                                              _dataObject.downloadCard();
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.download,
                                              size: 18,
                                              color: Colors.brown[900],
                                            ),
                                            label: Text("Save",
                                                style: TextStyle(
                                                    color: Colors.brown[900]))),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }, childCount: _dataObject.pictures.length)),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => _dataObject
                                    .videos[index].date ==
                                "${_todayDate.toLocal()}".split(' ')[0]
                            ? Card(
                                margin: EdgeInsets.only(
                                    left: 15, top: 10, right: 15, bottom: 10),
                                color: Colors.grey[300],
                                elevation: 8,
                                child: Column(
                                  children: [
                                    Container(
                                      child: BetterPlayer.network(
                                        api +
                                            "video/file/" +
                                            _dataObject.videos[index].id
                                                .toString(),
                                        betterPlayerConfiguration:
                                            BetterPlayerConfiguration(
                                          aspectRatio: 16 / 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.brown,
                                      height: 1.5,
                                    ),
                                    FlatButton.icon(
                                        color: Colors.black.withOpacity(0.4),
                                        onPressed: () {
                                          setState(() {
                                            _dataObject.url = api +
                                                "video/file/" +
                                                _dataObject.videos[index].id
                                                    .toString();

                                            _dataObject.title =
                                                '$index. Safhatussaalihiin_' +
                                                    _dataObject
                                                        .videos[index].date +
                                                    '.mp4';
                                          });
                                          _dataObject.downloadCard();
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.download,
                                          size: 18,
                                          color: Colors.brown[900],
                                        ),
                                        label: Text("Save",
                                            style: TextStyle(
                                                color: Colors.brown[900]))),
                                  ],
                                ),
                              )
                            : Container(),
                        childCount: _dataObject.videos.length)),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
