import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/event.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/event/create_event_view.dart";
import "package:hikup/widget/event_card.dart";
import "package:provider/provider.dart";

class AllEventView extends StatelessWidget {
  static String routeName = "all-event";
  const AllEventView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Gap(20.0),
              appState.events.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun évènement en cours",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: appState.events.length,
                      itemBuilder: (context, index) => EventCard(
                        event: EventModel(
                          name: appState.events[index].name,
                          description: appState.events[index].description,
                          localisation: appState.events[index].localisation,
                          visibilty: "",
                          tags: appState.events[index].tags,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          CreateEventView.routeName,
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
