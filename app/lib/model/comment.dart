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
  DateTime date;

  Comment({
    required this.id,
    required this.author,
    required this.body,
    required this.pictures,
    required this.date
  });
}
