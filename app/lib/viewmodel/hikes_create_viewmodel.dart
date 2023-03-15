import 'package:flutter/material.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/base_model.dart';

class HikeCreateViewModel extends BaseModel {
  int currentIndex = 0;
  List<List<String>> targets = [
    ["organized", "attendee", "guest"],
    ["attendee"],
    ["guest"]
  ];
  List<Tab> tabs = <Tab>[
    Tab(text: AppMessages.all),
    Tab(text: AppMessages.attended),
    Tab(text: AppMessages.guest),
  ];

  setCurrentIndex({required int index}) {
    currentIndex = index;
    notifyListeners();
  }
}
