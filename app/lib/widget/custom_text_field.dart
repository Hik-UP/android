import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikup/utils/constant.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TypeInput typeInput;
  final List<TextInputFormatter>? inputsFormatter;
  final TextInputType? keyBoardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final TypeOfInput typeOfInput;
  final Widget? prefixIcon;
  final Function()? onTap;
  final Function(String)? onChange;
  const CustomTextField({
    super.key,
    this.hintText = "",
    this.validator,
    this.controller,
    this.typeInput = TypeInput.text,
    this.inputsFormatter,
    this.keyBoardType,
    this.readOnly = false,
    this.suffixIcon,
    this.typeOfInput = TypeOfInput.text,
    this.prefixIcon,
    this.onTap,
    this.onChange,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obsureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      keyboardType: widget.keyBoardType,
      inputFormatters: widget.inputsFormatter,
      controller: widget.controller,
      validator: widget.validator,
      cursorColor: const Color.fromARGB(255, 0, 189, 41),
      obscureText: widget.typeOfInput == TypeOfInput.text ? false : obsureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.typeOfInput == TypeOfInput.text
            ? widget.suffixIcon
            : InkWell(
                onTap: () => setState(() {
                  obsureText = !obsureText;
                }),
                child: Icon(
                  obsureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                ),
              ),
      ),
    );
  }
}
