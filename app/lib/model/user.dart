import 'package:hive/hive.dart';
part "user.g.dart";

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String accountType;

  @HiveField(4)
  final String imageProfile;

  @HiveField(5)
  final List<dynamic> roles;

  @HiveField(6)
  final String token;

  @HiveField(7)
  final String? fcmToken;

  @HiveField(8)
  final String? verifyEmail;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.accountType,
      required this.imageProfile,
      required this.roles,
      required this.token,
      this.fcmToken,
      this.verifyEmail});

  static User fromMap({
    required Map<String, dynamic> data,
  }) {
    return User(
        id: data["id"] ?? "",
        name: data["username"] ?? "",
        email: data["email"] ?? "",
        token: data["token"] ?? "",
        roles: data["roles"] ?? [],
        accountType: "",
        imageProfile: data["picture"] ?? "",
        fcmToken: data["fcmToken"],
        verifyEmail: data["verifyEmail"]);
  }

  static printUser({required User user}) {
    print("${user.id} ==> ${user.roles} ==> ${user.token}");
  }

  static User copy({required User user}) {
    return User(
        id: user.id,
        name: user.name,
        email: user.email,
        accountType: user.accountType,
        imageProfile: user.imageProfile,
        roles: user.roles,
        token: user.token,
        fcmToken: user.fcmToken,
        verifyEmail: user.verifyEmail);
  }
}
