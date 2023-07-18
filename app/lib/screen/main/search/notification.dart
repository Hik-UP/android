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
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationView extends StatefulWidget {
  static String routeName = "/notification";
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      WrapperApi()
          .moveNotificationToRead(appState: context.read<AppState>())
          .then(
            (value) => setState(
              () {},
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    var _i18n = AppLocalizations.of(context)!;
    return BaseView<NotificationViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            _i18n.notificationText,
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
                        _i18n.anErrorOcur,
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
                            _i18n.noNotificationLabel,
                            style: subErrorTitleTextStyle,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => NotificationCard(
                          notification: snapshot.data![index],
                        ),
                      );
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
