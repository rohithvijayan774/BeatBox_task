import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final VoidCallback onPressed;
  final IconButton iconButton;
  final String coverPic;
  const SongTile(
      {required this.title,
      required this.artist,
      required this.onPressed,
      required this.iconButton,
      required this.coverPic,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: CircleAvatar(
        child: Image.asset(
          coverPic,
          scale: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'SofiaPro', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(color: Colors.grey, fontFamily: 'SofiaPro'),
      ),
      trailing: iconButton,
    );
  }
}
