import "package:flutter/material.dart";
import 'package:hikup/utils/constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TypeInput typeInput;
  const CustomTextField({
    Key? key,
    this.hintText = "",
    this.validator,
    this.controller,
    this.typeInput = TypeInput.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      ),
    );
  }
}
