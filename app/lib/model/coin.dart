class Coin {
  final String id;
  final double latitude;
  final double longitude;

  const Coin({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  static Coin fromMap({required Map<String, dynamic> data}) {
    return Coin(
      id: data["id"],
      latitude: data["latitude"],
      longitude: data["longitude"],
    );
  }
}
