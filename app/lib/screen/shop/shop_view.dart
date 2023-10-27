import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/shop/components/skin_display.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/shop_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
    context.read<AppState>().updateIfSkinHasChanged();

    return BaseView<ShopViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          label: AppMessages.shopLabel,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Gap(20.0),
              FutureBuilder<List<SkinWithOwner>>(
                future: model.getAllSkin(appState: appState),
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
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => SkinDisplay(
                        skin: snapshot.data![index],
                        borderColor: model.getBorderColor(
                          appState: appState,
                          skin: snapshot.data![index],
                        ),
                        updateScreen: () {
                          setState(() {});
                        },
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
      ),
    );
  }
}
