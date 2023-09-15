class OwnerSkin {
  final String id;
  final String username;

  const OwnerSkin({required this.id, required this.username});

  static OwnerSkin fromMap(Map<String, dynamic> data) {
    return OwnerSkin(
      id: data['id'],
      username: data['username'],
    );
  }

  static Map<String, dynamic> toMap(OwnerSkin data) {
    return {'id': data.id, 'username': data.username};
  }
}
