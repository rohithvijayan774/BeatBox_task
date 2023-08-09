import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/controller/provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class SongDetails extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String coverPic;
  final int index;

  const SongDetails({
    required this.title,
    required this.artist,
    required this.album,
    required this.coverPic,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log('$index');
    return Scaffold(
      body: Stack(
        children: [
         const RiveAnimation.asset('lib/assets/rive/shapes.riv'),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 70,
                sigmaY: 70,
              ),
              child: const SizedBox(),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(coverPic),
                      ),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 30),
                ),
                Text(
                  artist,
                  style: const TextStyle(fontFamily: 'SofiaPro', fontSize: 20),
                ),
                Consumer<MusicProvider>(builder: (context, value, _) {
                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: (value.isPlaying &&
                                value.currentPlayingIndex == index)
                            ? value.duration.inSeconds.toDouble()
                            : 0,
                        value: (value.isPlaying &&
                                value.currentPlayingIndex == index)
                            ? value.position.inSeconds.toDouble()
                            : 0,
                        onChanged: (v) async {
                          final position = Duration(seconds: v.toInt());
                          await value.audioPlayer.seek(position);

                          await value.audioPlayer.resume();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text((value.isPlaying &&
                                    value.currentPlayingIndex == index)
                                ? value.formatTime(value.position)
                                : '0.00'),
                            Text((value.isPlaying &&
                                    value.currentPlayingIndex == index)
                                ? value
                                    .formatTime(value.duration - value.position)
                                : '')
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (value.isPlaying &&
                              value.currentPlayingIndex == index) {
                            await value.pauseAudio();
                          } else {
                            await value.playAudio(value.songs[index], index);
                          }
                        },
                        icon: Icon(
                          (value.isPlaying &&
                                  value.currentPlayingIndex == index)
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 90,
                        ),
                      )
                    ],
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
