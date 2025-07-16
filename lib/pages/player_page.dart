import 'package:flutter/material.dart';
import 'package:audio_player_app/models/track.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  final List<Track> tracks;
  final int currentIndex;
  const PlayerPage({
    super.key,
    required this.tracks,
    required this.currentIndex,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late int _currentIndex;
  Track get currentTrack => widget.tracks[_currentIndex];
  late AudioPlayer _audioPlayer;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.currentIndex;
    _init();
  }

  Future<void> _init() async {
    try {
      await _audioPlayer.setAsset(currentTrack.path);
      await _audioPlayer.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _init();
    }
  }

  void _playNext() {
    if (_currentIndex < widget.tracks.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _init();
    }
  }

  Widget _buildPlayerUI() {
    return StreamBuilder(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 48,
              icon: Icon(Icons.skip_previous),
              onPressed: _playPrevious,
            ),
            IconButton(
              iconSize: 64,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                isPlaying ? _audioPlayer.pause() : _audioPlayer.play();
              },
            ),
            IconButton(
              iconSize: 48,
              icon: Icon(Icons.skip_next),
              onPressed: _playNext,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final total = _audioPlayer.duration ?? Duration.zero;

        return Column(
          children: [
            Slider(
              value: position.inSeconds.toDouble(),
              max: total.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
            Text(
              "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${total.inMinutes}:${(total.inSeconds % 60).toString().padLeft(2, '0')}",
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentTrack.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (currentTrack.albumImage != null)
              Image.asset(currentTrack.albumImage!, width: 350, height: 350),
            const SizedBox(height: 32),
            Text(currentTrack.title, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 32),
            _buildProgressBar(),
            const SizedBox(height: 20),
            _buildPlayerUI(), // теперь после слайдера
          ],
        ),
      ),
    );
  }
}
