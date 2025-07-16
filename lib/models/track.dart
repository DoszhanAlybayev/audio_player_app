
class Track {
  final String title;
  final String path; //путь до файла
  final String? albumImage;

  Track({
    required this.title,
    required this.path,
    this.albumImage,
  });
}
