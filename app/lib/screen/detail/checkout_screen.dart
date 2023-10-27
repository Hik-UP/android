import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:hikup/model/checkbox_state.dart';
import 'package:hikup/model/field_order.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/dummy_data.dart';

class CheckoutScreen extends StatefulWidget {
  final TrailFields field;

  const CheckoutScreen({required this.field, super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _controller = TextEditingController();
  DateTime _dateTime = DateTime.now();
  final dateFormat = DateFormat("EEEE, dd MMM yyyy");
  var availableBookTime = [
    CheckBoxState(title: "00.00"),
  ];
  int _totalBill = 0;
  bool _enableCreateOrderBtn = false;
  List<String> timeList = timeToBook;
  var currentTime = "00.00";

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });

    for (var time in timeList) {
      if (time == widget.field.openTime) {
        currentTime = time;
      }
    }

    availableBookTime.removeAt(0);
    for (int i = timeList.indexOf(currentTime); i < 24; i++) {
      if (currentTime == widget.field.closeTime) {
        break;
      } else {
        availableBookTime
            .add(CheckBoxState(title: "${timeList[i]} - ${timeList[i + 1]}"));
        currentTime = timeList[i + 1];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: HOPA,
              statusBarIconBrightness: Brightness.dark,
            ),
            title: Text("Checkout"),
            backgroundColor: HOPA,
            centerTitle: true,
            foregroundColor: HOPA,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: HOPABLUE, width: 2),
                        color: HOPABLUE,
                        borderRadius: BorderRadius.circular(borderRadiusSize)),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 24,
                          height: 24,
                          color: HOPABLUE,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(widget.field.name,
                            style: HOPASTYLE.copyWith(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Choisir une date",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: HOPA, width: 2),
                          color: HOPA,
                          borderRadius:
                              BorderRadius.circular(borderRadiusSize)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            color: HOPA,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            dateFormat.format(_dateTime).toString(),
                            style: HOPASTYLE,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Choisir l'heure",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ...availableBookTime.map(buildSingleCheckBox),
                ],
              ),
            ])),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: HOPA,
            offset: Offset(0, 0),
            blurRadius: 10,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total:",
                  style: HOPASTYLE,
                ),
                Text(
                  "h $_totalBill",
                  style: HOPASTYLE,
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusSize))),
                onPressed: !_enableCreateOrderBtn
                    ? null
                    : () {
                        List<String> selectedTime = [];
                        for (int i = 0; i < availableBookTime.length; i++) {
                          if (availableBookTime[i].value) {
                            selectedTime.add(availableBookTime[i].title);
                          }
                        }
                        dummyUserOrderList.add(FieldOrder(
                            field: widget.field,
                            user: sampleUser,
                            selectedDate:
                                dateFormat.format(_dateTime).toString(),
                            selectedTime: selectedTime));

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MainScreen.routeName, (route) => false);

                        _showSnackBar(context, "Réservation de la randonnée");
                      },
                child: Text(
                  "Réserver",
                  style: buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDate() async {
    await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 6))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  Widget buildSingleCheckBox(CheckBoxState checkbox) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(checkbox.title),
      value: checkbox.value,
      onChanged: (bool? value) {
        setState(() {
          checkbox.value = value!;
        });
        int totalSelectedTime = 0;
        for (int i = 0; i < availableBookTime.length; i++) {
          if (availableBookTime[i].value == true) {
            totalSelectedTime++;
          }
        }
        setState(() {
          _totalBill = widget.field.price * totalSelectedTime;
          if (totalSelectedTime > 0) {
            _enableCreateOrderBtn = true;
          } else {
            _enableCreateOrderBtn = false;
          }
        });
      },
    );
  }
}
