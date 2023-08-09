import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/controller/provider.dart';
import 'package:music_player/view/song_details.dart';
import 'package:music_player/widgets/song_tile.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    musicProvider.listenAudioState();
    musicProvider.listenAudioDuration();
    musicProvider.listenAudioPosition();

    return Scaffold(
        body: Stack(
      children: [
       const RiveAnimation.asset('lib/assets/rive/shapes.riv'),
        Column(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 70,
                  sigmaY: 70,
                ),
                child: const SizedBox(),
              ),
            ),
           const SizedBox(
              child: SizedBox(
                height: 100,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'BeatBox',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 50),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Consumer<MusicProvider>(builder: (context, value, _) {
                    return SongTile(
                      coverPic: value.coverPic[index],
                      title: value.titles[index],
                      artist: value.artist[index],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongDetails(
                                  index: index,
                                  title: value.titles[index],
                                  artist: value.artist[index],
                                  album: value.albums[index],
                                  coverPic: value.coverPic[index]),
                            ));
                      },
                      iconButton: IconButton(
                        onPressed: () async {
                          log('current index : ${value.currentPlayingIndex}');
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
                        ),
                      ),
                    );
                  });
                },
                itemCount: musicProvider.songs.length,
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
