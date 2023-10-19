import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/event.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/viewmodel/event_card_viewmodel.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/email_invite_card.dart";
import "package:provider/provider.dart";

class EventCard extends StatelessWidget {
  final EventModel event;
  final Function update;
  const EventCard({
    Key? key,
    required this.event,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<EventCardViewModel>(
      builder: (context, model, child) => SizedBox(
        width: double.infinity,
        child: Card(
          color: BlackPrimary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8.0),
                Text(
                  event.description,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Nombre de participant",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  event.participants.length.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
                const Gap(8.0),
                Visibility(
                  visible: event.tags.isNotEmpty,
                  child: Row(
                    children: event.tags
                        .map<Widget>(
                          (e) => EmailInviteCard(
                            showIcon: false,
                            email: e,
                            action: () {},
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Gap(8.0),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                          event.coverUrl,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                const Gap(10.0),
                if (event.participants.contains(appState.id))
                  CustomBtn(
                    content: "Se désinscrire",
                    isLoading: model.getState == ViewState.busy,
                    onPress: () {
                      model.participate(
                        appState: appState,
                        eventId: event.id,
                        path: "/event/unparticipate",
                        update: update,
                      );
                    },
                    bgColor: Colors.red,
                  )
                else
                  CustomBtn(
                    content: "Participer",
                    isLoading: model.getState == ViewState.busy,
                    onPress: () {
                      model.participate(
                        appState: appState,
                        eventId: event.id,
                        path: "/event/participate",
                        update: update,
                      );
                    },
                    bgColor: Colors.green,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
