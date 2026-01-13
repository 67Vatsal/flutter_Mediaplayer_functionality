import 'package:flutter/material.dart';
import 'media_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: MediaPlayerWidget(
              playlist: [
                // 1️⃣ Audio
                MediaItem(
                  url:
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                  type: MediaType.audio,
                  title: 'Audio 1',
                ),
                // 2️⃣ Video
                MediaItem(
                  url:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  type: MediaType.video,
                  title: 'Video 1',
                ),
                // 3️⃣ Audio
                MediaItem(
                  url:
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
                  type: MediaType.audio,
                  title: 'Audio 2',
                ),
                // 4️⃣ Video
                MediaItem(
                  url:
                  'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
                  type: MediaType.video,
                  title: 'Video 2',
                ),
                // 5️⃣ Audio
                MediaItem(
                  url:
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
                  type: MediaType.audio,
                  title: 'Audio 3',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
