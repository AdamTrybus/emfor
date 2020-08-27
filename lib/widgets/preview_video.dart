import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/network_video.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final bool chat;
  final String url;

  const PreviewVideo({@required this.chat, @required this.url});

  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  VideoPlayerController _controller;
  String url;
  bool chat, loading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((_) {
      url = widget.url;
      chat = widget.chat;
      _controller = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );
      _controller.addListener(() {
        setState(() {});
      });
      _controller.initialize();
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
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(NetworkVideo.routeName, arguments: url),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              height: chat ? 180 : 60,
              width: chat ? 200 : 80,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(_controller),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 54,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
