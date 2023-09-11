import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:hikup/model/skin.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/shop/components/skin_target.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/right_hike_tostring.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:provider/provider.dart";

class DialogContent extends StatelessWidget {
  final SkinWithOwner skin;
  const DialogContent({
    Key? key,
    required this.skin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkinTarget(
            skinUrlImage: skin.pictures[0],
          ),
          const Gap(20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomBtn(
                  bgColor: const Color(0xff7F7F7F),
                  content: AppMessages.changeLabel,
                  onPress: () => {},
                ),
              ),
              const Gap(8.0),
              Visibility(
                visible: !isAPartOfOwner(
                  ownerId: appState.id,
                  owners: skin.owners,
                ),
                child: Expanded(
                  child: CustomBtn(
                    bgColor: const Color(0xff15FF78),
                    content: AppMessages.buyLabel,
                    onPress: () => {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
