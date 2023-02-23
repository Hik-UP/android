import 'package:hive/hive.dart';
part "sensible_user_data.g.dart";

@HiveType(typeId: 3)
class SensibleUserData {
  @HiveField(0)
  final int age;
  @HiveField(1)
  final int weight;
  @HiveField(2)
  final int tall;
  @HiveField(3)
  final String sex;

  SensibleUserData({
    required this.age,
    required this.sex,
    required this.weight,
    required this.tall,
  });
}
