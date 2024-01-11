import 'dart:async';



import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';


class VideoWidget extends StatefulWidget {
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/nnnm.mp4')
      ..setVolume(5.0)
      ..initialize().then((_) {
        _controller.setVolume(5.0);

        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width:
                constraints.maxWidth * _controller.value.aspectRatio,
                height: constraints.maxHeight,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        },
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    print("Disposing video controller");
    _controller.pause();
    super.dispose();
    _controller.dispose();
  }
   void stopVideo() {
    _controller?.pause();
  }

}
