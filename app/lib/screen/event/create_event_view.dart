import "dart:io";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/viewmodel/create_event_viewmodel.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/checkbox_builder.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";
import "package:hikup/widget/email_invite_card.dart";
import "package:hikup/widget/file_upload_cmp.dart";
import "package:image_picker/image_picker.dart";

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
  List<String> typesOfEvent = ["Seul", "Groupe"];
  String currentVisibility = "Privée";
  String selectedTypeOfEvent = "Seul";
  List<String> tagEvent = [];
  TextEditingController eventNameCtrl = TextEditingController();
  TextEditingController eventDescriptionCtrl = TextEditingController();
  TextEditingController eventLocalisationCtrl = TextEditingController();
  TextEditingController tagCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CreateEventViewModel>(
      builder: (context, model, child) => Scaffold(
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
                CheckBoxBuilder(
                  values: visibilityType,
                  getCurrentValue: (String value) {
                    setState(() {
                      currentVisibility = value;
                    });
                  },
                ),
                CheckBoxBuilder(
                  values: typesOfEvent,
                  getCurrentValue: (String value) {
                    setState(() {
                      selectedTypeOfEvent = value;
                    });
                  },
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
                Text(
                  AppMessages.addACover4Event,
                  style: subTitleTextStyle,
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    FileUploadCmp.myAlert(
                      context: context,
                      getImageGallery: () =>
                          model.getImage(ImageSource.gallery),
                      getImageCamera: () => model.getImage(ImageSource.camera),
                    );
                  },
                  icon: const Icon(Icons.camera),
                ),
                if (model.image != null)
                  Image.file(
                    File(model.image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                const Gap(8.0),
                Visibility(
                  visible: selectedTypeOfEvent == "Groupe",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.inviteFriendLabel,
                        style: subTitleTextStyle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: tagCtrl,
                              hintText: "email",
                            ),
                          ),
                          const Gap(8.0),
                          CustomBtn(
                            content: "Inviter",
                            onPress: () {},
                            bgColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(70.0),
                CustomBtn(
                  isLoading: model.getState == ViewState.busy,
                  content: AppMessages.validateLabel,
                  onPress: () {
                    model.createEvent(
                      appState: appState,
                      title: eventNameCtrl.text,
                      description: eventDescriptionCtrl.text,
                      tags: tagEvent,
                      localisation: eventLocalisationCtrl.text,
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
