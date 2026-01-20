enum MediaType { audio, video }

class MediaItem {
  final String url;
  final MediaType type;
  final String title;

  MediaItem({
    required this.url,
    required this.type,
    required this.title,
  });
}
