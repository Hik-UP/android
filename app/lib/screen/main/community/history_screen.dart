import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/no_community_message.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: BlackPrimary,
      body: Center(
        child: SingleChildScrollView(
          child: NoCommunityMessage(
            messageTitle: "",
            messageDesc: "",
          ),
        ),
      ),
    );
  }
}
