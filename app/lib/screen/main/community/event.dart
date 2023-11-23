import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/no_community_message.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

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
