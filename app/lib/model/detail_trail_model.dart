class DetailTrailMode {
  final int temperature;
  final String iconTemp;
  final List<String> tools;
  final List<String> relatedArticles;
  final int calories;

  const DetailTrailMode({
    required this.temperature,
    required this.iconTemp,
    required this.tools,
    required this.relatedArticles,
    required this.calories,
  });

  static DetailTrailMode fromMap({
    required Map<String, dynamic> data,
  }) {
    List<String> toolsAsString = (data["tools"] as List<dynamic>)
        .map<String>((value) => value as String)
        .toList();
    List<String> articleAsString = (data["relatedArticles"] as List<dynamic>)
        .map<String>((value) => value as String)
        .toList();

    return DetailTrailMode(
      temperature: data["weather"]["temperature"],
      iconTemp: data["weather"]["icon"],
      tools: toolsAsString,
      relatedArticles: articleAsString,
      calories: data["calories"],
    );
  }
}
