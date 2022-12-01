import 'package:hikup/model/rando_field.dart';
import 'package:hikup/model/user.dart';

class FieldOrder {
  RandoField field;
  User user;
  String selectedDate;
  List<String> selectedTime;
  bool paidStatus;

  FieldOrder(
      {required this.field,
      required this.user,
      required this.selectedDate,
      required this.selectedTime,
      this.paidStatus = false});
}
