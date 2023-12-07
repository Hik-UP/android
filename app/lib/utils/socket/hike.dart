import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/model/navigation.dart';

class HikeSocket {
  IO.Socket? socket;
  final _navigator = locator<CustomNavigationService>();

  HikeSocket({required this.socket});

  void onJoin(Function(dynamic) func) {
    try {
      socket?.on('hike:hiker:join', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onLeave(Function(dynamic) func) {
    try {
      socket?.on('hike:hiker:leave', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onMove(Function(dynamic) func) {
    try {
      socket?.on('hike:hiker:move', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onGetCoin(Function(dynamic) func) {
    try {
      socket?.on('hike:coin:get', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void onEnd(Function(dynamic) func) {
    try {
      socket?.on('hike:end', func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  Future<void> join(String hikeId, Function(dynamic) func) async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
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

      socket?.emitWithAck('hike:hiker:join', data[0], ack: func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }

  void move(Position position, HikerStats stats, Function(dynamic) func) {
    try {
      final data = [
        {
          "data": {
            "hiker": {
              "latitude": position.latitude,
              "longitude": position.longitude,
              "stats": {
                "steps": stats.steps,
                "distance": stats.distance,
                "completed": stats.completed
              }
            },
          },
        }
      ];
      socket?.emitWithAck('hike:hiker:move', data[0], ack: func);
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
