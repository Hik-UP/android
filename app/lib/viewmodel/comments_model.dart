class CommentPhoto {
  String username;
  String body;
  List<String> pictures;

  CommentPhoto(
      {required this.username, required this.body, required this.pictures});

  factory CommentPhoto.fromJson(Map<String, dynamic> json) {
    return CommentPhoto(
      username: json['author']['username'],
      body: json['body'],
      pictures: List<String>.from(json['pictures']),
    );
  }
}
