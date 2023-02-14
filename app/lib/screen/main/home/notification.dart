import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';
import 'package:hikup/widget/back_icon.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/notification_card.dart';

class NotificationView extends StatelessWidget {
  static String routeName = "/notification";
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 3,
          automaticallyImplyLeading: false,
          leading: const BackIcon(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Gap(20.0),
              Column(
                children: List.generate(
                  7,
                  (index) => const NotificationCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
