import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/event.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";
import "package:hikup/widget/email_invite_card.dart";

import "package:provider/provider.dart";

const spaceBetweenWidget = Gap(10.0);

class CreateEventView extends StatefulWidget {
  static String routeName = "/create-event-view";
  const CreateEventView({Key? key}) : super(key: key);

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  List<String> visibilityType = ["Privée", "Public"];
  String currentVisibility = "Privée";
  List<String> tagEvent = [];
  TextEditingController eventNameCtrl = TextEditingController();
  TextEditingController eventDescriptionCtrl = TextEditingController();
  TextEditingController eventLocalisationCtrl = TextEditingController();
  TextEditingController tagCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppMessages.eventNameLabel,
                style: subTitleTextStyle,
              ),
              CustomTextField(
                controller: eventNameCtrl,
              ),
              spaceBetweenWidget,
              Text(
                AppMessages.eventDescription,
                style: subTitleTextStyle,
              ),
              CustomTextField(
                maxLine: 3,
                controller: eventDescriptionCtrl,
              ),
              spaceBetweenWidget,
              Text(
                AppMessages.localisationLabel,
                style: subTitleTextStyle,
              ),
              CustomTextField(
                controller: eventLocalisationCtrl,
              ),
              spaceBetweenWidget,
              Text(
                AppMessages.visibilityOfTheEvent,
                style: subTitleTextStyle,
              ),
              Row(
                children: visibilityType
                    .map<Widget>(
                      (vis) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: currentVisibility == vis,
                            onChanged: (e) {
                              setState(() {
                                currentVisibility = vis;
                              });
                            },
                          ),
                          Text(
                            vis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              Text(
                AppMessages.addTagEvent,
                style: subTitleTextStyle,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: tagCtrl,
                      hintText: "Tag",
                    ),
                  ),
                  const Gap(8.0),
                  CustomBtn(
                    content: "Ajouter",
                    onPress: () {
                      tagEvent.add(tagCtrl.text);
                      tagCtrl.clear();
                      setState(() {});
                    },
                    bgColor: Colors.blue,
                  ),
                ],
              ),
              const Gap(8.0),
              tagEvent.isEmpty
                  ? Text(
                      "Aucun tag ajouté",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    )
                  : Row(
                      children: tagEvent
                          .map<Widget>(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: EmailInviteCard(
                                email: e,
                                action: () {},
                              ),
                            ),
                          )
                          .toList(),
                    ),
              const Gap(8.0),
              const Gap(70.0),
              CustomBtn(
                content: AppMessages.validateLabel,
                onPress: () {
                  appState.addNewEvent(
                    EventModel(
                      name: eventNameCtrl.text,
                      description: eventDescriptionCtrl.text,
                      localisation: eventLocalisationCtrl.text,
                      visibilty: "",
                      tags: tagEvent,
                    ),
                  );

                  Navigator.of(context).pop();
                },
                bgColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}