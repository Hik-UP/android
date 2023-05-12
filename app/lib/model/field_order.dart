import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/user.dart';

class FieldOrder {
  TrailFields field;
  User user;
  String selectedDate;
  List<String> selectedTime;
  bool paidStatus;

  FieldOrder({
    required this.field,
    required this.user,
    required this.selectedDate,
    required this.selectedTime,
    this.paidStatus = false,
  });
}
