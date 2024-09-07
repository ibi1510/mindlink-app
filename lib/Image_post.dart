import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImagePost extends StatefulWidget {
  const ImagePost({super.key});

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  void _image() async {
    const url =
        "https://cdn-employer-wp.arc.dev/wp-content/uploads/2022/04/good-software-developer-1128x635.jpg";
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
        title: Text('MindLink Images',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 350,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/download.jpg'),fit: BoxFit.cover),
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 20,
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
                  _image();
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
