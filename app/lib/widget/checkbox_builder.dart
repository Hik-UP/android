import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CheckBoxBuilder extends StatefulWidget {
  final List<String> values;
  final Function(String value) getCurrentValue;
  const CheckBoxBuilder({
    super.key,
    required this.values,
    required this.getCurrentValue,
  });

  @override
  State<CheckBoxBuilder> createState() => _CheckBoxBuilderState();
}

class _CheckBoxBuilderState extends State<CheckBoxBuilder> {
  String currentValue = "";

  @override
  void initState() {
    super.initState();
    currentValue = widget.values[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.values
          .map<Widget>(
            (vis) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: currentValue == vis,
                  onChanged: (e) {
                    setState(() {
                      currentValue = vis;
                      widget.getCurrentValue(currentValue);
                    });
                  },
                ),
                Text(
                  vis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
