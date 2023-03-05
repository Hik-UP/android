class Author {
  String username;
  String picture;

  Author({
    required this.username,
    required this.picture,
  });
}

class Comment {
  String id;
  Author author;
  String body;
  List<String> pictures;
  String date;

  Comment({
    required this.id,
    required this.author,
    required this.body,
    required this.pictures,
    required this.date
  });
}
