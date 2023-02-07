import 'package:flutter/widgets.dart';
import 'package:hikup/utils/constant.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  void setState(ViewState value) {
    _state = value;
    notifyListeners();
  }

  ViewState get getState => _state;
}
