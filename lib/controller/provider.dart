import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicProvider extends ChangeNotifier {
  bool isPlaying = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  int _currentPlayingIndex = -1;
  int get currentPlayingIndex => _currentPlayingIndex;

  final audioPlayer = AudioPlayer();

  List songs = [
    'Ghoomar_Padmavati.mp3',
    'DilDiyanGallan_DownloadMing.mp3',
    'Dilbar_SatyamevaJayate.mp3',
    'DingDang_MunnaMichael.mp3',
    'EkDilEkJaan_Padmavati.mp3',
    'NazmNazm_MusicBadshah.mp3',
    'TumhariSulu_BanJaRani.mp3',
  ];

  List<String> titles = [
    'Ghoomar',
    'Dil Diyan Gallan',
    'Dilbar',
    'Ding Dang',
    'Ek Dil Ek Jaan',
    'Nazm Nazm',
    'Ban Ja Rani',
  ];

  List<String> albums = [
    'Padmavati',
    'Tiger Zinda Hai',
    'Satyameva Jayate',
    'Munna Michael',
    'Padmavati',
    'Bareilly Ki Barfi',
    'Tumhari Sulu',
  ];

  List<String> artist = [
    'Shreya Ghoshal, Swaroop Khan',
    'Atif Aslam',
    'Neha Kakkar, Ikka Singh, Dhvani Bhanushali',
    'Amit Mishra, Antara Mitra',
    'Shivam Pathak',
    'Pravo Mukherjee',
    'Guru Randhawa',
  ];

  List coverPic = [
    'lib/assets/img/Ghoomar.jpg',
    'lib/assets/img/DilDIyaGallan.jpg',
    'lib/assets/img/Dilbar.jpg',
    'lib/assets/img/DingDang.jpg',
    'lib/assets/img/EkDilEkJan.jpg',
    'lib/assets/img/NazmNazm.jpg',
    'lib/assets/img/BanJaRani.jpg',
  ];

  Future playAudio(String selectedSong, int index) async {
    final player = AudioCache(prefix: 'lib/assets/music/');
    final url = await player.load(selectedSong);
    await audioPlayer.play(
      UrlSource(url.path),
    );
    _currentPlayingIndex = index;
    notifyListeners();
  }

  pauseAudio() async {
    await audioPlayer.pause();

    _currentPlayingIndex = -1;
    notifyListeners();
  }

  listenAudioState() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;

      notifyListeners();
    });
  }

  listenAudioDuration() {
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      notifyListeners();
    });
  }

  listenAudioPosition() {
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      notifyListeners();
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,minutes,seconds,
    ].join(':');
  }
}
