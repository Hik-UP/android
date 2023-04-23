import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/complete_profile_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_drop_down.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

class HeadPlaceHolder extends StatelessWidget {
  final String label;
  final Widget child;
  const HeadPlaceHolder({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: subTitleTextStyle,
        ),
        const Gap(4.0),
        child
      ],
    );
  }
}

class CompleteProfile extends StatelessWidget {
  static String routeName = "/complete-profile";
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CompleteProfileViewModel>(builder: (context, model, child) {
      model.initializeInputForm(appState: context.read<AppState>());
      return Scaffold(
        appBar: AppBar(
          title: Text(
          AppMessages.completeProfil,
          style: titleTextStyleWhite,
        ),
          iconTheme: IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
          ),
          toolbarHeight: kToolbarHeight,
          backgroundColor: BlackSecondary,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Form(
            key: model.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: HeadPlaceHolder(
                        label: "Age",
                        child: CustomTextField(
                          controller: model.ageCtrl,
                          keyBoardType: TextInputType.number,
                          hintText: "Age",
                          validator: model.requiredField,
                          inputsFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                        ),
                      ),
                    ),
                    const Gap(8.0),
                    Expanded(
                      child: HeadPlaceHolder(
                        label: AppMessages.weightPlaceHolder,
                        child: CustomTextField(
                          controller: model.weightCtrl,
                          keyBoardType: TextInputType.number,
                          hintText: AppMessages.weight,
                          validator: model.requiredField,
                          inputsFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20.0),
                HeadPlaceHolder(
                  label: AppMessages.gender,
                  child: CustomDropDown(
                    getSelectedGender: (String gender) {
                      model.setGenderValue(value: gender);
                      model.setDropDownIsActive(value: false);
                    },
                    inputController: model.genderCtrl,
                    isVisible: model.dropDownIsActive,
                    onTap: () {
                      model.setDropDownIsActive(value: !model.dropDownIsActive);
                    },
                    hintText: AppMessages.selectSex,
                    content: const ["M", "F"],
                  ),
                ),
                Visibility(
                  visible: model.isGenderError,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(6.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          AppMessages.selectSex,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20.0),
                HeadPlaceHolder(
                  label: AppMessages.height,
                  child: CustomTextField(
                    controller: model.tallCtrl,
                    keyBoardType: TextInputType.number,
                    hintText: AppMessages.addHeight,
                    validator: model.requiredField,
                    inputsFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                  ),
                ),
                const Gap(20.0),
                CustomBtn(
                  gradient: loginButtonColor,
                  content: AppMessages.save,
                  isLoading: model.getState == ViewState.busy,
                  onPress: () {
                    model.genderNotNull();
                    if (model.formKey.currentState!.validate()) {
                      model.completeData(
                        sensibleUserData: SensibleUserData(
                          age: int.parse(model.ageCtrl.text),
                          sex: model.gender,
                          weight: int.parse(model.weightCtrl.text),
                          tall: int.parse(model.tallCtrl.text),
                        ),
                        appState: context.read<AppState>(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
