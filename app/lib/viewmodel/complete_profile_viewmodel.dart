import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class CompleteProfileViewModel extends BaseModel {
  String? gender;
  bool dropDownIsActive = false;
  bool isGenderError = false;
  bool isInit = false;
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

  String? ageValidator(String? age) {
    if (age == null || age.isEmpty) {
      return "Age obligatoire";
    } else if (double.tryParse(age) == null) {
      return "Age incorrect";
    } else if (double.tryParse(age)! < 16 || double.tryParse(age)! > 90) {
      return "Entre 16 et 90 ans";
    }

    return null;
  }

  String? weightValidator(String? weight) {
    if (weight == null || weight.isEmpty) {
      return "Poids obligatoire";
    } else if (double.tryParse(weight) == null) {
      return "Poids incorrect";
    } else if (double.tryParse(weight)! < 40 ||
        double.tryParse(weight)! > 220) {
      return "Entre 40 et 220 kg";
    }

    return null;
  }

  String? heightValidator(String? height) {
    if (height == null || height.isEmpty) {
      return "Taille obligatoire";
    } else if (double.tryParse(height) == null) {
      return "Taille incorrecte";
    } else if (double.tryParse(height)! < 140 ||
        double.tryParse(height)! > 260) {
      return "Entre 140 et 260 cm";
    }

    return null;
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
      genderCtrl.text =
          appState.sensibleUserData.sex == 'H' ? 'Homme' : 'Femme';
      tallCtrl.text = appState.sensibleUserData.tall.toString();
      gender = appState.sensibleUserData.sex;
    }
    isInit = true;
  }
}
