class EventModel {
  final String name;
  final String description;
  final String localisation;
  final String visibilty;
  final List<String> tags;

  EventModel({
    required this.name,
    required this.description,
    required this.localisation,
    required this.visibilty,
    required this.tags,
  });
}
