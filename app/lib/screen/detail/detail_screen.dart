import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/detail_trail_model.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/detail_screen_viewmodel.dart';
import 'package:hikup/widget/back_icon.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/widget/email_invite_card.dart';
import 'package:hikup/widget/invite_friend_cmp.dart';
import 'package:hikup/widget/show_burn_calories.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final TrailFields field;

  const DetailScreen({required this.field, Key? key}) : super(key: key);

  String putZero({required int value}) {
    return value >= 0 && value <= 9 ? "0$value" : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<DetailScreenViewModel>(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(field: field),
            SliverPadding(
              padding: const EdgeInsets.only(
                  right: 24, left: 24, bottom: 24, top: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        pinIcon,
                        width: 24,
                        height: 24,
                        color: primaryColor500,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Flexible(
                        child: Text(
                          field.address,
                          overflow: TextOverflow.visible,
                          style: addressTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        CupertinoIcons.money_dollar_circle_fill,
                        color: primaryColor500,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                    ],
                  ),
                  const Gap(10.0),
                  Text(
                    "Details",
                    style: subTitleTextStyle,
                  ),
                  const Gap(4.0),
                  FutureBuilder<DetailTrailMode>(
                    future: WrapperApi().getDetailsTrails(
                      appState: appState,
                      trailId: field.id,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            AppMessages.anErrorOcur,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor500,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Image.network(
                                    data!.iconTemp,
                                    height: 24.0,
                                  ),
                                ),
                                const Gap(16.0),
                                Text(
                                  "${putZero(value: data.temperature)} deg",
                                  style: descTextStyle,
                                ),
                              ],
                            ),
                            const Gap(16.0),
                            ShowBurnCalories(calories: data.calories),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    },
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.escalator,
                        color: primaryColor500,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                    ],
                  ),
                  const Gap(10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Duration",
                        style: subTitleTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: primaryColor500,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${field.duration}",
                        style: descTextStyle,
                      ),
                    ],
                  ),
                  const Gap(10.0),
                  Text(
                    "Tools",
                    style: subTitleTextStyle,
                  ),
                  const Gap(4.0),
                  model.showTools(toolsBack: field.tools),
                  const Gap(10.0),
                  Text(
                    AppMessages.inviteFriend,
                    style: subTitleTextStyle,
                  ),
                  const Gap(4.0),
                  const InviteFriendCmp(),
                  const Gap(10.0),
                  Row(
                    children: [
                      EmailInviteCard(
                        email: "imdadadelabou0@gmail.com",
                        action: () {},
                      ),
                    ],
                  )
                  //FacilityCardList(facilities: field.tools),
                ]),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: lightBlue300,
              offset: Offset(0, 0),
              blurRadius: 10,
            ),
          ]),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusSize))),
            onPressed: () {
              /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CheckoutScreen(
                  field: field,
                );
              }));*/
            },
            child: const Text("Réserver maintenant"),
          ),
        ),
      ),
    );
  }
}
