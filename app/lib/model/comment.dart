import 'package:hive_flutter/hive_flutter.dart';
part 'comment.g.dart';

@HiveType(typeId: 7)
class Author {
  @HiveField(0)
  String username;
  @HiveField(1)
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

@HiveType(typeId: 6)
class Comment {
  @HiveField(0)
  String id;
  @HiveField(1)
  Author author;
  @HiveField(2)
  String body;
  @HiveField(3)
  List<String> pictures;
  @HiveField(4)
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
      ).toLocal(),
    );
  }
}
