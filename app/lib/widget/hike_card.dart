import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/hike/detail_hike_invite.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/hike_card_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:provider/provider.dart';

class HikeCard extends StatelessWidget {
  final Hike hike;
  final Function() update;
  const HikeCard({
    Key? key,
    required this.hike,
    required this.update,
  }) : super(key: key);

  String formatDate() {
    var replaceDate = hike.schedule.replaceAll(RegExp(r'T'), ' ');
    var splitDate = replaceDate.split(' ');

    return "${splitDate[0]} ${splitDate[1].split(':').sublist(0, 2).join(':')}";
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<HikeCardViewModel>(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailHikeInvite(
                hike: hike,
              ),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: BlackPrimary,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          idHikeIcon,
                          width: 20,
                          height: 20,
                          color: GreenPrimary,
                        ),
                        const Gap(8.0),
                        Text(
                          "Informations",
                          style: subTitleTextStyle,
                        ),
                      ],
                    ),
                    model.labelStatus(
                      status: hike.status,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    hike.name,
                    style: WhiteAddressTextStyle,
                  ),
                ),
                const Gap(10.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      calendarIcon,
                      width: 20,
                      height: 20,
                      color: GreenPrimary,
                    ),
                    const Gap(8.0),
                    Text(
                      AppMessages.date,
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    formatDate(),
                    style: WhiteAddressTextStyle,
                  ),
                ),
                const Gap(10.0),
                Row(
                  children: [
                    Image.asset(
                      pinIcon,
                      width: 18,
                      height: 18,
                      color: GreenPrimary,
                    ),
                    const Gap(8.0),
                    Text(
                      AppMessages.position,
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    hike.address,
                    style: WhiteAddressTextStyle,
                  ),
                ),
                Visibility(
                  visible: model
                      .retriveGuestName(guests: hike.guests)
                      .contains(appState.username),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomBtn(
                          isLoading: model.declineLoader,
                          textColor: Colors.red,
                          content: AppMessages.decliner,
                          onPress: () {
                            model.acceptOrRefuse(
                              routeName: declineInvitePath,
                              hikeId: hike.id,
                              appState: appState,
                              load: () => model.setDeclineLoader(true),
                              stop: () {
                                model.setDeclineLoader(false);
                                update();
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomBtn(
                          isLoading: model.acceptLoader,
                          content: AppMessages.accepter,
                          onPress: () {
                            model.acceptOrRefuse(
                              routeName: acceptInvitePath,
                              hikeId: hike.id,
                              appState: appState,
                              load: () => model.setAcceptLoader(true),
                              stop: () {
                                model.setAcceptLoader(false);
                                update();
                              },
                            );
                          },
                        ),
                      ),
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
