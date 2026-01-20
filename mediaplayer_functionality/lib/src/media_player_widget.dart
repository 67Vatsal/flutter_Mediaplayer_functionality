import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'media_item.dart';
import 'media_player_controller.dart';

class MediaPlayerWidget extends StatefulWidget {
  final List<MediaItem> playlist;
  const MediaPlayerWidget({super.key, required this.playlist});

  @override
  State<MediaPlayerWidget> createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  late MediaPlayerController controller;
  bool loading = true;
  bool showControls = true;
  Timer? _hideTimer;

  Duration audioPosition = Duration.zero;
  Duration audioDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    controller = MediaPlayerController();
    _init();
  }

  Future<void> _init() async {
    await controller.loadPlaylist(widget.playlist);

    // Listen to audio position
    controller.audioPositionStream.listen((pos) {
      if (!mounted) return;
      setState(() => audioPosition = pos);
    });

    // Listen to audio duration
    controller.audioDurationStream.listen((dur) {
      if (!mounted) return;
      if (dur != null) setState(() => audioDuration = dur);
    });

    if (!mounted) return;
    setState(() => loading = false);

    await controller.play();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => showControls = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator(color: Colors.white));

    final media = controller.current;

    return GestureDetector(
      onTap: () {
        setState(() => showControls = !showControls);
        _startHideTimer();
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // MEDIA VIEW
          Center(
            child: media.type == MediaType.video
                ? ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller.videoController!,
              builder: (context, value, _) {
                if (!value.isInitialized) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                return AspectRatio(
                  aspectRatio: value.aspectRatio,
                  child: VideoPlayer(controller.videoController!),
                );
              },
            )
                : const Icon(Icons.music_note, size: 120, color: Colors.white),
          ),

          // CONTROLS
          if (showControls)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // VIDEO SEEK
                  if (media.type == MediaType.video)
                    VideoProgressIndicator(
                      controller.videoController!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.white54,
                        backgroundColor: Colors.white24,
                      ),
                    ),

                  // AUDIO SEEK
                  if (media.type == MediaType.audio)
                    Column(
                      children: [
                        if (audioDuration.inMilliseconds > 0)
                          Slider(
                            value: audioPosition.inMilliseconds
                                .clamp(0, audioDuration.inMilliseconds)
                                .toDouble(),
                            max: audioDuration.inMilliseconds.toDouble(),
                            min: 0,
                            onChanged: (value) {
                              controller.seekAudio(Duration(milliseconds: value.toInt()));
                            },
                            activeColor: Colors.red,
                            inactiveColor: Colors.white30,
                          )
                        else
                          const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _timeText(audioPosition),
                              _timeText(audioDuration),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 6),

                  // BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _btn(Icons.skip_previous, () => controller.previous()),
                      _btn(Icons.replay_10, () => controller.rewind()),
                      _btn(Icons.play_arrow, () => controller.play()),
                      _btn(Icons.pause, () => controller.pause()),
                      _btn(Icons.forward_10, () => controller.fastForward()),
                      _btn(Icons.skip_next, () => controller.next()),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, Future<void> Function() onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () async {
        await onPressed();
        if (mounted) setState(() {});
      },
    );
  }

  Widget _timeText(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return Text('$m:$s', style: const TextStyle(color: Colors.white, fontSize: 12));
  }
}
