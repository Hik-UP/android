import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/notification.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_loader.dart';
import 'package:hikup/widget/notification_card.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:provider/provider.dart';
import '../../../theme.dart';

class NotificationView extends StatelessWidget {
  static String routeName = "/notification";
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<NotificationViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            AppMessages.notificationText,
            style: titleTextStyleWhite,
          ),
          iconTheme: const IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
          ),
          backgroundColor: BlackPrimary,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              FutureBuilder<List<NotificationModel>>(
                future: WrapperApi().getAllNotification(
                  appState: appState,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppMessages.anErrorOcur,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Text(
                            AppMessages.noNotificationLabel,
                            style: subErrorTitleTextStyle,
                          ),
                        ),
                      );
                    } else {
                      return Text("Data");
                    }
                  }

                  return const Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Center(
                      child: CustomLoader(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
