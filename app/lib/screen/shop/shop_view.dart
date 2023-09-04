import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/shop/components/skin_display.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/widget/custom_app_bar.dart';

class ShopView extends StatelessWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: AppMessages.shopLabel,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Gap(20.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => SkinDisplay(),
            ),
          ],
        ),
      ),
    );
  }
}
