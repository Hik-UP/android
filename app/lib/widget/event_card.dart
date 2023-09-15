import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/event.dart";
import "package:hikup/theme.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/email_invite_card.dart";

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
              const Gap(10.0),
              CustomBtn(
                content: "Participer",
                onPress: () {},
                bgColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
