import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Safhatussaalihiin extends StatefulWidget {
  @override
  _SafhatussaalihiinState createState() => _SafhatussaalihiinState();
}

class _SafhatussaalihiinState extends State<Safhatussaalihiin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/back.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.amber[50].withOpacity(0.7), BlendMode.lighten),
        )),
        child: ListView(
          children: [
            Image(
              image: AssetImage("assets/icons/safhatussaalihiin.png"),
              height: 150,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[400],
                      child: Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      String socialUrl = "https://twitter.com/salafitz1?s=09";
                      _launchURL(socialUrl);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.purple[800],
                      child: Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      String socialUrl =
                          "https://www.instagram.com/safhatussaalihiin/";
                      _launchURL(socialUrl);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      var phone = "+255718656210";
                      String socialUrl = "whatsapp://send?phone=$phone";
                      _launchURL(socialUrl);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.lightBlue[700],
                      child: Icon(
                        FontAwesomeIcons.telegramPlane,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      String socialUrl = "https://t.me/safhatussaalihiin";
                      _launchURL(socialUrl);
                    },
                  ),
                )
              ],
            ),
            Divider(
                indent: 100, thickness: 2, endIndent: 100, color: Colors.brown),
            Container(
              height: 300,
              // width: 5,
              child: Image(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/images/Picture5.png")),
            ),
          ],
        ));
  }

  _launchURL(String linkUrl) async {
    if (await canLaunch(linkUrl)) {
      await launch(linkUrl);
    } else {
      throw 'Could not launch $linkUrl';
    }
  }
}
