import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String imageUrl;

  VideoPlayerScreen({Key? key,required this.imageUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  Widget popupWidget(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
    return AlertDialog(
        backgroundColor: Colors.transparent,
        actions: [
          Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: AppColor.whiteColor,),
        ]
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.network(widget.imageUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(title: const Text('Video Player'),),
      body: !_controller.value.isInitialized
          ? const Center(child: Text('Loading...')) :
      Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
                //   showDialog(
                //       context: context,
                //       builder: (ctxt) =>
                //       AlertDialog(
                //         backgroundColor: Colors.transparent,
                //         actions: [
                //           Center(child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: AppColor.whiteColor,size: 40,)),
                //         ]
                //       )
                //   );
                //   Future.delayed(const Duration(seconds: 1), () {
                //     Navigator.of(context).pop();
                //   });
              },
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: Visibility(
                      visible: !_controller.value.isPlaying,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColor.appColor,
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: const Icon(
                          Icons.play_arrow,color: AppColor.whiteColor,size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                      left: 0,right: 0,
                      child: VideoProgressIndicator(_controller, allowScrubbing: true))
                ],
              )),),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: AppColor.whiteColor,
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
