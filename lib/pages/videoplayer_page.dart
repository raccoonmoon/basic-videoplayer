import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

enum Source { asset, network }

class VideoplayerPage extends StatefulWidget {
  const VideoplayerPage({super.key});

  @override
  State<VideoplayerPage> createState() => _VideoplayerPageState();
}

class _VideoplayerPageState extends State<VideoplayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;

  Source currentSource = Source.asset;

  Uri videoUri = Uri.parse(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');

  String assetVideoPath = 'assets/videos/5362421-uhd_3840_2160_25fps.mp4';
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                  _sourceButtons()
                ],
              ),
            ),
    );
  }

  Widget _sourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        MaterialButton(
          color: Colors.red,
          child: Text(
            'Network',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.network;
              initializeVideoPlayer(currentSource);
            });
          },
        ),
        MaterialButton(
          color: Colors.red,
          child: Text(
            'Assets',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.asset;
              initializeVideoPlayer(currentSource);
            });
          },
        )
      ],
    );
  }

  void initializeVideoPlayer(Source source) {
    setState(() {
      isLoading = true;
    });
    CachedVideoPlayerController videoPlayerController;
    if (source == Source.asset) {
      videoPlayerController = CachedVideoPlayerController.asset(assetVideoPath)
        ..initialize().then((value) {
          setState(() {
            isLoading = false;
          });
        });
    } else if (source == Source.network) {
      videoPlayerController =
          CachedVideoPlayerController.network(videoUri.toString())
            ..initialize().then(
              (value) {
                setState(() {
                  isLoading = false;
                });
              },
            );
    } else {
      return;
    }

    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: videoPlayerController);
  }
}
