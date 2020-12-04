import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mirfat_frontend/api.dart';
import 'package:mirfat_frontend/providers/data_provider.dart';
import 'package:provider/provider.dart';
// import 'package:videos_player/model/video.model.dart';
// import 'package:videos_player/videos_player.dart';

class SearchScreen extends StatefulWidget {
  final DataProvider dataObject;

  const SearchScreen({Key key, @required this.dataObject}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime selectedDate = DateTime.now();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);

    return Container(
        key: _scaffoldKey,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/back.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.amber[50].withOpacity(0.7), BlendMode.lighten),
        )),
        child: Column(children: [
          InkWell(
            child: Container(
              height: 65,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                leading: Icon(Icons.today, color: Colors.white),
                title: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                trailing: Icon(
                  FontAwesomeIcons.angleDown,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              _selectDate(context);
            },
          ),
          Expanded(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return _dataObject.pictures[index].date ==
                          "${selectedDate.toLocal()}".split(' ')[0]
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
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.download,
                                                size: 18,
                                                color: Colors.brown[900],
                                              ),
                                              label: Text("Save",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.brown[900]))),
                                        )
                                      ],
                                    )),
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
                                "${selectedDate.toLocal()}".split(' ')[0]
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
                                        // child: VideosPlayer(networkVideos: [
                                        //   NetworkVideo(
                                        //       videoUrl: api +
                                        //           "video/file/" +
                                        //           _dataObject.videos[index].id
                                        //               .toString())
                                        // ]),
                                        ),
                                    Container(
                                      color: Colors.brown,
                                      height: 1.5,
                                    ),
                                    Container(
                                      child: FlatButton.icon(
                                          color: Colors.black.withOpacity(0.4),
                                          onPressed: () {},
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
                              )
                            : Container(),
                        childCount: _dataObject.videos.length)),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Divider(
                      height: 0,
                      thickness: 5,
                      color: Colors.brown[300],
                    ),
                  )
                ])),
                SliverToBoxAdapter(
                    child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Image(
                        image: NetworkImageWithRetry(api +
                            "picture/file/" +
                            _dataObject.pictures[index].id.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    itemCount: _dataObject.pictures.length,
                  ),
                )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Divider(
                      height: 0,
                      thickness: 2,
                      color: Colors.brown[300],
                    ),
                  )
                ])),
                SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                  // height: MediaQuery.of(context).size.height*3/5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width*3/4,
                      padding: EdgeInsets.only(left: 5),
                      child: AspectRatio(
                        aspectRatio: 9/6 ,
                        child: BetterPlayer.network(
                          api +
                              "video/file/" +
                              _dataObject.videos[index].id.toString(),
                          betterPlayerConfiguration:
                              BetterPlayerConfiguration(
                            aspectRatio: 8 / 7,
                          ),
                        ),
                      ),
                    ),
                    itemCount: _dataObject.videos.length,
                    
                  ),
                ))
              ],
            ),
          ),
        ]));
  }
}
