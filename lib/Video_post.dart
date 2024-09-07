import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({super.key});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF3D6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('MindLink Videos',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Videos").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: VideoApp(
                      url: snapshot.data!.docs[index]['url'],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => SelectvideoPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SelectvideoPage extends StatefulWidget {
  const SelectvideoPage({super.key});

  @override
  State<SelectvideoPage> createState() => _SelectvideoPageState();
}

class _SelectvideoPageState extends State<SelectvideoPage> {
  VideoPlayerController? _controller;
  String url = '';
  File? videofile;
  bool isUploading = false;

  Future<void> uploadVideo() async {
    if (videofile == null) return;
    setState(() {
      isUploading = true;
    });

    try {
      var ref =
          FirebaseStorage.instance.ref().child("Videos/${videofile!.path}");
      await ref.putFile(File(videofile!.path));
      url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("Videos")
          .doc()
          .set({"url": url});

      Navigator.pop(context);
    } catch (e) {
      print("Upload failed: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF3D6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? galleryVideo =
                      await picker.pickVideo(source: ImageSource.gallery);
                  if (galleryVideo != null) {
                    videofile = File(galleryVideo.path);
                    _controller = VideoPlayerController.file(videofile!)
                      ..initialize().then((_) {
                        setState(() {});
                      });
                  }
                },
                child: Center(
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "Select Video",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                )),
            if (_controller != null && _controller!.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            if (_controller != null)
              TextButton(
                  onPressed: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  },
                  child: Text(
                    _controller!.value.isPlaying ? "Pause" : "Play",
                    style: TextStyle(fontSize: 20),
                  )),
            if (_controller != null)
              TextButton(
                  onPressed: () async {
                    await uploadVideo();
                  },
                  child: Text(
                    "Upload",
                    style: TextStyle(fontSize: 20),
                  )),
            if (isUploading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
            child: Text(
          "Select Video page",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({super.key, required this.url});
  final String url;

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Center all children in the Stack
      children: [
        Container(
          color: Colors.blue,
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
        ),
        Positioned(
          child: IconButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50, // Increase the size of the icon for better visibility
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
