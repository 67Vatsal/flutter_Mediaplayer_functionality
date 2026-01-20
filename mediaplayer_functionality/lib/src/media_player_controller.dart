import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'media_item.dart';

class MediaPlayerController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _videoController;

  List<MediaItem> _playlist = [];
  int _index = 0;

  MediaItem get current => _playlist[_index];
  VideoPlayerController? get videoController => _videoController;

  // Audio streams
  Stream<Duration> get audioPositionStream => _audioPlayer.positionStream;
  Stream<Duration?> get audioDurationStream => _audioPlayer.durationStream;

  // Playlist
  Future<void> loadPlaylist(List<MediaItem> list, {int startIndex = 0}) async {
    _playlist = list;
    _index = startIndex;
    await _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    await stop();

    if (current.type == MediaType.audio) {
      await _audioPlayer.setUrl(current.url);

      // Audio completion listener
      _audioPlayer.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          next();
        }
      });
    } else {
      _videoController?.removeListener(_videoListener);
      await _videoController?.dispose();

      _videoController = VideoPlayerController.networkUrl(Uri.parse(current.url));
      await _videoController!.initialize();
      await _videoController!.setLooping(false);

      _videoController!.addListener(_videoListener);
    }
  }

  void _videoListener() {
    if (_videoController!.value.isInitialized) {
      final pos = _videoController!.value.position;
      final dur = _videoController!.value.duration;
      if (pos >= dur - const Duration(milliseconds: 500) &&
          !_videoController!.value.isPlaying) {
        next();
      }
    }
  }

  // Playback
  Future<void> play() async {
    if (current.type == MediaType.audio) {
      await _audioPlayer.play();
    } else {
      await _videoController?.play();
    }
  }

  Future<void> pause() async {
    if (current.type == MediaType.audio) {
      await _audioPlayer.pause();
    } else {
      await _videoController?.pause();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _videoController?.pause();
  }

  Future<void> next() async {
    if (_index < _playlist.length - 1) {
      _index++;
      await _loadCurrent();
      await play();
    }
  }

  Future<void> previous() async {
    if (_index > 0) {
      _index--;
      await _loadCurrent();
      await play();
    }
  }

  Future<void> fastForward() async {
    if (current.type == MediaType.audio) {
      await _audioPlayer.seek(_audioPlayer.position + const Duration(seconds: 10));
    } else {
      await _videoController?.seekTo(
          _videoController!.value.position + const Duration(seconds: 10));
    }
  }

  Future<void> rewind() async {
    if (current.type == MediaType.audio) {
      await _audioPlayer.seek(_audioPlayer.position - const Duration(seconds: 10));
    } else {
      await _videoController?.seekTo(
          _videoController!.value.position - const Duration(seconds: 10));
    }
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _videoController?.dispose();
  }
}
