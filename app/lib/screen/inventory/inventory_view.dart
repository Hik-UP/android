import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/skin.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/inventory/skin_inventory_card.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/wrapper_api.dart";
import "package:hikup/viewmodel/skin_display_viewmodel.dart";
import "package:hikup/widget/base_view.dart";

import "package:provider/provider.dart";

class InventoryView extends StatelessWidget {
  static String routeName = "/inventory";
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();

    return BaseView<SkinDisplayViewModel>(
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              appState.skin.pictures[0],
              scale: 0.7,
            ),
            Text(
              "Avatars :",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Gap(10.0),
            FutureBuilder<List<SkinWithOwner>>(
              future: WrapperApi().getAllSkin(
                appState: context.watch<AppState>(),
                routeName: "/user/skin/unlocked",
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    AppMessages.anErrorOcur,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      AppMessages.noSkinLabel,
                      style: subErrorTitleTextStyle,
                    ),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => model.openDialog(
                          skin: snapshot.data![index], action: () {}),
                      child: SkinInventoryCard(
                        img: index <= snapshot.data!.length - 1
                            ? snapshot.data![index].pictures[0]
                            : null,
                      ),
                    ),
                  );
                }

                return const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
