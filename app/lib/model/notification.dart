class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool read;
  final String dateTime;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
    required this.dateTime,
  });

  static fromMap({required Map<String, dynamic> data}) {
    return NotificationModel(
      id: data["id"],
      title: data["title"],
      body: data["body"],
      read: data["read"],
      dateTime: data["dateTime"],
    );
  }
}
