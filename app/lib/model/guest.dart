class Guest {
  final String username;
  final String picture;

  const Guest({
    required this.username,
    required this.picture,
  });

  static Guest fromMap({required Map<String, dynamic> data}) {
    return Guest(
      username: data["username"],
      picture: data["picture"],
    );
  }
}
