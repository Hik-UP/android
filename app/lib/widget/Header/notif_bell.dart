import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/main/search/notification.dart";
import "package:hikup/viewmodel/notif_viewmodel.dart";
import "package:hikup/widget/base_view.dart";
import "package:provider/provider.dart";

// NotifyViewModel

class NotifBell extends StatelessWidget {
  const NotifBell({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    return BaseView<NotifyViewModel>(
      builder: (context, model, child) => InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          NotificationView.routeName,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FutureBuilder<bool>(
              future: model.showNotifBellOrNot(appState),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Visibility(
                    visible: snapshot.data!,
                    child: Positioned(
                      right: 0,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 23, 255, 119),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }

                return const Text('');
              },
            ),
            const Icon(
              FontAwesomeIcons.bell,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
