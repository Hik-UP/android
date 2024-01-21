import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanComponent extends StatefulWidget {
  final TextEditingController dateCtrl;
  final TextEditingController timeCtrl;
  final Key? formKey;
  const PlanComponent(
      {super.key,
      required this.dateCtrl,
      required this.timeCtrl,
      this.formKey});

  @override
  State<PlanComponent> createState() => _PlanComponentState();
}

class _PlanComponentState extends State<PlanComponent> {
  Future<DateTime?> customShowPicker() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().toLocal(),
      firstDate: DateTime.now().toLocal(),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('fr'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: Colors.black, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black // <-- SEE HERE
              ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              // button text color
            ),
          ),
        ),
        child: child!,
      ),
    );
  }

  String? validateDate(String? date) {
    if ((date == null || date.isEmpty) && (widget.timeCtrl.text.isNotEmpty)) {
      return "Veuillez sélectionner une date";
    }
    return null;
  }

  String? validateTime(String? time) {
    if ((time == null || time.isEmpty) && (widget.dateCtrl.text.isNotEmpty)) {
      return "Veuillez sélectionner une heure";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Programmez votre randonnée",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
        const Gap(10.0),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: widget.dateCtrl,
                validator: validateDate,
                hintText: 'Date',
                prefixIcon: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: SvgPicture.asset(
                    "assets/icons/calendarIcon.svg",
                    width: 14.0,
                    height: 14.0,
                    fit: BoxFit.scaleDown,
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await customShowPicker();
                  if (pickedDate != null) {
                    String formateDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    setState(() {
                      widget.dateCtrl.text = formateDate;
                    });
                  }
                },
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Heure',
                controller: widget.timeCtrl,
                validator: validateTime,
                prefixIcon: SvgPicture.asset(
                  stopWatchIcon,
                  width: 14.0,
                  height: 14.0,
                  fit: BoxFit.scaleDown,
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                readOnly: true,
                onTap: () async {
                  var pickHours = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.dialOnly,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              timePickerTheme: TimePickerThemeData(
                                backgroundColor: Colors.white,
                                hourMinuteShape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                hourMinuteColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        states.contains(MaterialState.selected)
                                            ? Colors.grey.withOpacity(0.3)
                                            : Colors.white),
                                hourMinuteTextColor: Colors.black,
                                dialHandColor: Colors.black,
                                dialBackgroundColor:
                                    Colors.grey.withOpacity(0.3),
                              ),
                              /*colorScheme: const ColorScheme.light(
                                primary: Colors.grey, // <-- SEE HERE
                                onPrimary: Colors.black, // <-- SEE HERE
                                onSurface: Colors.black, // <-- SEE HERE
                              ),*/
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          ));
                  if (pickHours != null) {
                    widget.timeCtrl.text =
                        "${pickHours.hour.toString().padLeft(2, '0')}:${pickHours.minute.toString().padLeft(2, '0')}";
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
