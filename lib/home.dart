import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mirfat_frontend/providers/data_provider.dart';
import 'package:mirfat_frontend/views/screens/search_screen.dart';
import 'package:mirfat_frontend/views/screens/safhatussaalihiin_screen.dart';
import 'package:mirfat_frontend/views/screens/live_screen.dart';
import 'package:mirfat_frontend/views/screens/today_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String url = "dffgdg";

  @override
  Widget build(BuildContext context) {
    final _dataObject =Provider.of<DataProvider>(context);
    List<Widget> _screens = [
      TodayScreen(dataObject: _dataObject,),
      SearchScreen(dataObject: _dataObject,),
      LiveScreen(),
      Safhatussaalihiin(),
    ];
    return Scaffold(
        backgroundColor: Colors.amber[100].withOpacity(1),
        appBar: AppBar(
          backgroundColor: Colors.brown[900],
          toolbarHeight: 45,
          leading: Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Image(
              color: Colors.amber[200],
              image: AssetImage("assets/icons/safhatussaalihiin.png"),
            ),
          ),
          title: _selectedIndex == 0
              ? Text(
                  "Today's Posts",
                  style: TextStyle(color: Colors.white),
                )
              : _selectedIndex == 1
                  ? Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    )
                  : _selectedIndex == 2
                      ? Text(
                          'Live',
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          'Safhatussaalihiin',
                          style: TextStyle(color: Colors.white),
                        ),
          actions: [
            _selectedIndex == 3
                ? IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Share.share(url);
                    })
                : Container()
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.brown[900],
          buttonBackgroundColor: Colors.brown,
          height: 50,
          animationDuration: Duration(
            milliseconds: 100,
          ),
          index: 0,
          animationCurve: Curves.bounceInOut,
          items: <Widget>[
            Icon(Icons.today, size: 25, color: Colors.white),
            Icon(Icons.search, size: 25, color: Colors.white),
            Icon(Icons.live_tv, size: 25, color: Colors.white),
            Icon(Icons.info, size: 25, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
