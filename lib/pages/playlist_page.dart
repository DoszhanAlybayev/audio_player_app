import 'package:audio_player_app/components/my_drawer.dart';
import 'package:audio_player_app/pages/player_page.dart';
import 'package:flutter/material.dart';
import 'package:audio_player_app/models/track.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final List<Track> tracks = [
    Track(
      title: 'Хочу перемен!',
      path: 'assets/audio/track1.mp3',
      albumImage: 'assets/images/album1.jpg',
    ),
    Track(
      title: 'Nightcall',
      path: 'assets/audio/track2.mp3',
      albumImage: 'assets/images/album2.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text('P L A Y L I S T')),
      drawer: MyDrawer(),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          final track = tracks[index];
          return ListTile(
            leading: track.albumImage != null
                ? Image.asset(
                    track.albumImage!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.music_note),
            title: Text(track.title),
            onTap: () {
              //переход на плеер
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerPage(tracks: tracks,
                  currentIndex: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
