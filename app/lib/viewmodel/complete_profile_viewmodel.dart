import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class CompleteProfileViewModel extends BaseModel {
  String gender = "";
  bool dropDownIsActive = false;
  bool isGenderError = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController genderCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController tallCtrl = TextEditingController();
  final _hiveService = locator<HiveService>();
  final _navigator = locator<CustomNavigationService>();

  setDropDownIsActive({required bool value}) {
    dropDownIsActive = value;
    notifyListeners();
  }

  setIsGenderError({required bool value}) {
    isGenderError = value;
    notifyListeners();
  }

  setGenderValue({required String value}) {
    gender = value;
    notifyListeners();
  }

  bool genderNotNull() {
    if (gender != "M" && gender != "F") {
      setIsGenderError(value: true);

      return (false);
    }

    setIsGenderError(value: false);
    return true;
  }

  String? requiredField(String? value) {
    if (value != null && value.isNotEmpty) return null;

    return AppMessages.isRequired;
  }

  completeData({
    required SensibleUserData sensibleUserData,
    required AppState appState,
  }) async {
    try {
      setState(ViewState.busy);
      await _hiveService.addOnBoxViaKey<SensibleUserData>(
        sensibleUserDataBox,
        "sensibleUserData",
        sensibleUserData,
      );
      setState(ViewState.retrieved);
      appState.updateSensibleDataState(value: sensibleUserData);
      _navigator.goBack();
      _navigator.showSnackBack(
        content: "Votre profil a été sauvegardé.",
      );
    } catch (e) {
      setState(ViewState.retrieved);
    }
  }

  initializeInputForm({required AppState appState}) {
    var sensibleUserData = appState.sensibleUserData;
    if (sensibleUserData.age != 0 &&
        sensibleUserData.tall != 0 &&
        sensibleUserData.weight != 0) {
      ageCtrl.text = appState.sensibleUserData.age.toString();
      weightCtrl.text = appState.sensibleUserData.weight.toString();
      genderCtrl.text = appState.sensibleUserData.sex;
      tallCtrl.text = appState.sensibleUserData.tall.toString();
    }
  }
}
