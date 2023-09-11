import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/screen/shop/components/skin_display.dart";
import "package:hikup/screen/shop/components/skin_target.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";

class DialogContent extends StatelessWidget {
  const DialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkinTarget(),
          const Gap(20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomBtn(
                bgColor: const Color(0xff7F7F7F),
                content: AppMessages.changeLabel,
                onPress: () => {},
              ),
              const Gap(8.0),
              CustomBtn(
                bgColor: const Color(0xff15FF78),
                content: AppMessages.buyLabel,
                onPress: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
