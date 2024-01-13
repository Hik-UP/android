import 'package:hive/hive.dart';
part "settings.g.dart";

@HiveType(typeId: 8)
class Settings {
  @HiveField(0)
  final double? volume;

  Settings({this.volume});
}
