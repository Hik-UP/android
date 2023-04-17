import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/detail_trail_model.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/detail_screen_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/widget/email_invite_card.dart';
import 'package:hikup/widget/invite_friend_cmp.dart';
import 'package:hikup/widget/plan_component.dart';
import 'package:hikup/widget/show_burn_calories.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final Box<String> boxtrailId = Hive.box('trailId');


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
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          pinIcon,
                          width: 24,
                          height: 24,
                          color: GreenPrimary,
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Flexible(
                          child: Text(
                            field.address,
                            overflow: TextOverflow.visible,
                            style: WhiteAddressTextStyle,
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
                          color: GreenPrimary,
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
                        boxtrailId.put("trailId", field.id);
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
                                    child: 
                                    GestureDetector(
                                    onTap: () { Navigator.of(context).pushNamed("/community");},
                                    child : Icon(
                                      Icons.add_box,
                                      color: GreenPrimary,
                                      size: 24.0
                                    ),
                                  )),
                                  const Gap(16.0),
                                  Text(
                                    "Users comments",
                                    style: WhiteAddressTextStyle,
                                  ),
                                const Gap(16.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: GreenPrimary,
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
                                    style: WhiteAddressTextStyle,
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
                          color: GreenPrimary,
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
                          color: GreenPrimary,
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          "${field.duration}",
                          style: WhiteAddressTextStyle,
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
                    InviteFriendCmp(
                      value: (data) => model.pushInEmailFirends(
                        value: data,
                      ),
                    ),
                    const Gap(10.0),
                    Visibility(
                      visible: model.emailFriends.isNotEmpty,
                      child: SizedBox(
                        height: 40.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: model.emailFriends.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: EmailInviteCard(
                              email: model.emailFriends[index],
                              action: () {
                                model.removeInEmailFriends(
                                  value: model.emailFriends[index],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10.0),
                    Text(
                      AppMessages.schedule,
                      style: subTitleTextStyle,
                    ),
                    PlanComponent(
                      dateCtrl: model.dateCtrl,
                      timeCtrl: model.timeCtrl,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            model.dateCtrl.text = "";
                            model.timeCtrl.text = "";
                          },
                          child: Text(
                            AppMessages.reset,
                            style: GreenSubTitleTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: BlackPrimary,
            boxShadow: [
              BoxShadow(
                color: GreenPrimary,
                offset: Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: loginButtonColor,
            borderRadius: BorderRadius.circular(borderRadiusSize),
            ),
            constraints: BoxConstraints(
              minWidth: 100,
              minHeight: 45,
            ),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadiusSize),
              ),
            ),
            onPressed: model.getState == ViewState.busy
                ? null
                : () {
                    model.createAHike(
                      appState: appState,
                      trailField: field,
                      timeStamps: model.dateCtrl.text.isNotEmpty &&
                              model.timeCtrl.text.isNotEmpty
                          ? model.timeStampOrNull()
                          : null,
                      guests: model.emailFriends,
                    );
                  },
            child: model.getState == ViewState.busy
                ? const CircularProgressIndicator()
                : Text(
                    AppMessages.startNow,
                    style: subTitleTextStyle,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
