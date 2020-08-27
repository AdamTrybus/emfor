import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideo extends StatefulWidget {
  static const String routeName = "network-video";

  @override
  _NetworkVideoState createState() => _NetworkVideoState();
}

class _NetworkVideoState extends State<NetworkVideo> {
  VideoPlayerController _controller;
  String url;
  bool boxSize, loading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((_) {
      url = ModalRoute.of(context).settings.arguments;
      _controller = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );
      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize();
      _controller.play();
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 36,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      _PlayPauseOverlay(controller: _controller),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
