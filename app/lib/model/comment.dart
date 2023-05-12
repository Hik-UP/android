class Author {
  String username;
  String picture;

  Author({
    required this.username,
    required this.picture,
  });

  static Author fromMap({required Map<String, dynamic> data}) {
    return Author(
      username: data["username"],
      picture: data["picture"],
    );
  }
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
    required this.date,
  });

  static Comment fromMap({required Map<String, dynamic> data}) {
    return Comment(
      id: data["id"],
      author: Author.fromMap(data: data["author"]),
      body: data["body"] ?? "",
      pictures: (data["pictures"] as List).isNotEmpty
          ? (data["pictures"] as List).map<String>((e) => e as String).toList()
          : [],
      date: DateTime.parse(
        data["date"],
      ),
    );
  }
}
