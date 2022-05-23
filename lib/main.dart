import 'package:flutter/material.dart';
import 'package:hik_up/pages/LoginPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hik\'Up',
      home: LoginPage(),
    );
  }
}

void main() {
  runApp(const MyApp());
}