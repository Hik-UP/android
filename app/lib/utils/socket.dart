import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:geolocator/geolocator.dart';

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
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .setQuery(
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
      print(e);
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

  void onJoinHikeSuccess(Function(dynamic) func) {
    try {
      socket?.on('joinHikeSuccess', func);
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

  void onHikeLeaved(Function(dynamic) func) {
    try {
      socket?.on('hikeLeaved', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onHikerMoved(Function(dynamic) func) {
    try {
      socket?.on('hikerMoved', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  joinHike(String hikeId) async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final data = [
        {
          "data": {
            "hike": {"id": hikeId},
            "hiker": {
              "latitude": position.latitude,
              "longitude": position.longitude
            },
          },
        }
      ];
      socket?.emit('joinHike', data[0]);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void move(Position position) {
    try {
      final data = [
        {
          "data": {
            "hiker": {
              "latitude": position.latitude,
              "longitude": position.longitude
            },
          },
        }
      ];
      socket?.emit('move', data[0]);
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
