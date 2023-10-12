import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/achievement_card.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanComponent extends StatefulWidget {
  final TextEditingController dateCtrl;
  final TextEditingController timeCtrl;
  const PlanComponent({
    Key? key,
    required this.dateCtrl,
    required this.timeCtrl,
  }) : super(key: key);

  @override
  State<PlanComponent> createState() => _PlanComponentState();
}

class _PlanComponentState extends State<PlanComponent> {
  Future<DateTime?> customShowPicker() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: BlackPrimary, // <-- SEE HERE
            onPrimary: Colors.white, // <-- SEE HERE
            onSurface: Colors.blueAccent, // <-- SEE HERE
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
              // button text color
            ),
          ),
        ),
        child: child!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "(${AppMessages.canPlanTheHike})",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
            color: const Color(0xff666666),
          ),
        ),
        const Gap(10.0),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.dateCtrl,
                hintText: 'Date',
                prefixIcon: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: SvgPicture.asset(
                    stopWatchIcon,
                    width: 14.0,
                    height: 14.0,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await customShowPicker();
                  if (pickedDate != null) {
                    String formateDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      widget.dateCtrl.text = formateDate;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 7.0),
            Expanded(
              child: CustomTextField(
                hintText: 'Heure',
                controller: widget.timeCtrl,
                prefixIcon: SvgPicture.asset(
                  stopWatchIcon,
                  width: 14.0,
                  height: 14.0,
                  fit: BoxFit.scaleDown,
                ),
                readOnly: true,
                onTap: () async {
                  var pickHours = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: BlackPrimary, // <-- SEE HERE
                                onPrimary: Colors.white, // <-- SEE HERE
                                onSurface: Colors.blueAccent, // <-- SEE HERE
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          ));
                  if (pickHours != null) {
                    widget.timeCtrl.text =
                        "${pickHours.hour}:${pickHours.minute}";
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
