import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/detail_screen_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/widget/display_address.dart';
import 'package:hikup/widget/display_detail_trails.dart';
import 'package:hikup/widget/email_invite_card.dart';
import 'package:hikup/widget/invite_friend_cmp.dart';
import 'package:hikup/widget/plan_component.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final TrailFields field;
  const DetailScreen({required this.field, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    String durationToString(int minutes) {
      var d = Duration(minutes: minutes);
      List<String> parts = d.toString().split(':');
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

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
                    DisplayAddress(address: field.address),
                    const Gap(16),
                    Row(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: field.labels
                              .map(
                                (label) => Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  margin: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    "${label}",
                                    style: subTitleTextStyle,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const Gap(10.0),
                    Text(
                      "Description",
                      style: subTitleTextStyle,
                    ),
                    const Gap(8.0),
                    Text(
                      field.description.toString(),
                      textAlign: TextAlign.justify,
                      style: WhiteAddressTextStyle,
                    ),
                    const Gap(10.0),
                    Text(
                      "Détails",
                      style: subTitleTextStyle,
                    ),
                    const Gap(10.0),
                    DisplayDetailTrails(
                      trailId: field.id,
                      duration: "${durationToString(field.duration)}",
                      upHill: "${field.uphill} m",
                      downHill: "${field.downhill} m",
                      tools: field.tools,
                      difficulty: field.difficulty.toString(),
                      articles: field.relatedArticles,
                    ),
                    const Gap(10.0),
                    Text(
                      AppMessages.inviteFriend,
                      style: subTitleTextStyle,
                    ),
                    const Gap(8.0),
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
                //color: GreenPrimary,
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
            constraints: const BoxConstraints(
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
                      model.dateCtrl.text.isEmpty
                          ? AppMessages.startHike
                          : AppMessages.scheduleHike,
                      style: subTitleTextStyle,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
