import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/socket/hike.dart';

IO.Socket? socket;

class SocketService {
  final _navigator = locator<CustomNavigationService>();
  final hike = HikeSocket(socket: socket);

  void connect({
    required String token,
    required String userId,
    required List<dynamic> userRoles,
  }) {
    try {
      socket = IO.io(
          baseSocketUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .setAuth(
                  {'token': token, 'id': userId, 'roles': userRoles.join(",")})
              .disableAutoConnect()
              .build());
      socket?.connect();
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void disconnect() {
    try {
      socket?.disconnect();
      socket?.clearListeners();
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

  void onDisconnect(Function(dynamic) func) {
    try {
      socket?.onDisconnect(func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onError(Function(dynamic) func) {
    try {
      socket?.onError(func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void test() {
    try {
      socket
        ?..disconnect()
        ..connect();
      socket?.emit('msg', 'test');
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
