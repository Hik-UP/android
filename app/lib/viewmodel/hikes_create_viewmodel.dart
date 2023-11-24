import 'package:flutter/material.dart';
import 'package:hikup/viewmodel/base_model.dart';

class HikeCreateViewModel extends BaseModel {
  int currentIndex = 0;
  List<List<String>> targets = [
    ["attendee"],
    ["guest"],
    ["leaved"]
  ];

  List<Tab> tabs = <Tab>[
    const Tab(text: "Randonnées"),
    const Tab(text: "Invitations"),
    const Tab(text: "Historique"),
  ];

  setCurrentIndex({required int index}) {
    currentIndex = index;
    notifyListeners();
  }
}
