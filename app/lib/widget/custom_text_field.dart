import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:hikup/utils/constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TypeInput typeInput;
  final List<TextInputFormatter>? inputsFormatter;
  final TextInputType? keyBoardType;
  final bool readOnly;
  final Widget? suffixIcon;
  const CustomTextField({
    Key? key,
    this.hintText = "",
    this.validator,
    this.controller,
    this.typeInput = TypeInput.text,
    this.inputsFormatter,
    this.keyBoardType,
    this.readOnly = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: keyBoardType,
      inputFormatters: inputsFormatter,
      controller: controller,
      validator: validator,
      cursorColor: const Color.fromARGB(255, 0, 189, 41),
      obscureText: typeInput == TypeInput.password,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
