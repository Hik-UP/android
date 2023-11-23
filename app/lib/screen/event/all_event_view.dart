import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/event.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/event/create_event_view.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/viewmodel/all_event_viewmodel.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/custom_loader.dart";
import "package:hikup/widget/event_card.dart";
import "package:provider/provider.dart";

class AllEventView extends StatefulWidget {
  static String routeName = "all-event";
  const AllEventView({super.key});

  @override
  State<AllEventView> createState() => _AllEventViewState();
}

class _AllEventViewState extends State<AllEventView> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return BaseView<AllEventViewModel>(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const Gap(20.0),
                FutureBuilder<List<EventModel>>(
                  future: model.getAllEvent(appState: appState),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppMessages.anErrorOcur,
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Aucun évènement en cours",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => EventCard(
                            event: snapshot.data![index],
                            update: () => setState(() {}),
                          ),
                        );
                      }
                    }

                    return const Center(
                      child: CustomLoader(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(
                CreateEventView.routeName,
              )
              .then(
                (value) => Future.delayed(
                  const Duration(seconds: 4),
                  () => setState(() {}),
                ),
              ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
