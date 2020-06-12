import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  static _VideoItem of(BuildContext context) =>
      context.findAncestorStateOfType<_VideoItem>();
  const VideoItem({Key key, this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  _VideoItem createState() => _VideoItem();
}

class _VideoItem extends State<VideoItem> {
  VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    startVideo(widget.videoPath);
  }

  startVideo(String videoPath) {
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() {
          _controller.setVolume(0);
          initialized = true;
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? Container(
            height: 200,
            width: 100,
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
  }
}
