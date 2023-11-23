import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/shop/components/skin_target.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/right_hike_tostring.dart';
import 'package:hikup/viewmodel/skin_display_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:provider/provider.dart';

class SkinDisplay extends StatelessWidget {
  final SkinWithOwner skin;
  final Color borderColor;
  final Function() updateScreen;

  const SkinDisplay({
    super.key,
    required this.skin,
    this.borderColor = const Color(0xff000000),
    required this.updateScreen,
  });

  @override
  Widget build(BuildContext context) {
    print(skin);
    return BaseView<SkinDisplayViewModel>(
      builder: (context, model, child) => SizedBox(
        child: InkWell(
          onTap: () => model.openDialog(
            skin: skin,
            action: updateScreen,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            color: const Color(0xff222222),
            elevation: 3,
            child: Column(
              children: [
                const Gap(3.0),
                SkinTarget(
                  skinUrlImage: skin.pictures[0],
                ),
                Visibility(
                  visible: !isAPartOfOwner(
                    ownerId: context.watch<AppState>().id,
                    owners: skin.owners,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        coinIcon,
                        width: 16,
                        height: 16,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        '${skin.price}\$',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
