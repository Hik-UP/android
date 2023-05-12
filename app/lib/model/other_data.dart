import 'package:hive/hive.dart';
part "other_data.g.dart";

@HiveType(typeId: 1)
class OtherData {
  @HiveField(0)
  final bool isFirstDownload;

  OtherData({
    this.isFirstDownload = true,
  });
}
