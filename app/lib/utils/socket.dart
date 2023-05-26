import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';

IO.Socket? socket = null;

class SocketService {
  final _navigator = locator<CustomNavigationService>();

  void connect({
    required String token,
    required String userId,
    required List<dynamic> userRoles,
  }) {
    try {
      socket = IO.io(
          "$baseSocketUrl",
          IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
            'token': token
          }).setQuery({'id': userId, 'roles': userRoles.join(",")}).build());
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onConnect(Function(dynamic) func) {
    try {
      socket?.onConnect(func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onHikeJoined(Function(dynamic) func) {
    try {
      socket?.on('hikeJoined', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void joinHike(String hikeId) {
    try {
      socket?.emit('joinHike', hikeId);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void test() {
    try {
      socket?.emit('msg', 'test');
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
