import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextPost extends StatefulWidget {
  const TextPost({super.key});

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  void _companyWebsite() async {
    const url =
        "https://www.falconebiz.com/company/MINDLINK-PLATFORM-PRIVATE-LIMITED-U62090KA2024PTC186608";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //   error
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF3D6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('MindLink Text',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Touch the share button',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(Icons.arrow_circle_down_sharp),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffE5C955),
                    Color(0xffA35F1B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _companyWebsite
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
