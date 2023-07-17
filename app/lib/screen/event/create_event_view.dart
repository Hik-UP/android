import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/custom_text_field.dart";

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

  @override
  Widget build(BuildContext context) {
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
             const CustomTextField(),
              spaceBetweenWidget,
              Text(
                AppMessages.eventDescription,
                style: subTitleTextStyle,
              ),
             const CustomTextField(
                maxLine: 3,
              ),
              spaceBetweenWidget,
              Text(
                AppMessages.localisationLabel,
                style: subTitleTextStyle,
              ),
              const CustomTextField(),
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
              const Gap(70.0),
              CustomBtn(content: AppMessages.validateLabel, onPress: () {}, bgColor: Colors.green,),
            ],
          ),
        ),
      ),
    );
  }
}
