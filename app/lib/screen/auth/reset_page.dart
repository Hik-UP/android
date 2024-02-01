import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/viewmodel/reset_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:provider/provider.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/utils/app_messages.dart';

import '../../../theme.dart';

class ResetPage extends StatefulWidget {
  static String routeName = "/reset-page";
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  bool isInit = false;
  bool isLoading = false;
  bool isReset = true;
  bool verifyEmail = false;
  bool showPasswordField = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BaseView<ResetPageModel>(builder: (context, model, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isInit == false) {
          if (arguments['isReset'] != null && arguments['isReset'] == false) {
            model.emailCtrl.text = appState.email;
            setState(() {
              isReset = false;
              isLoading = true;
            });
            model.request(
                appState: appState,
                email: model.emailCtrl.text,
                onVerify: () {
                  setState(() {
                    verifyEmail = true;
                    isLoading = false;
                  });
                });
          }
          setState(() {
            isInit = true;
          });
        }
      });

      return ScaffoldWithCustomBg(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            "Réinitialisation",
            style: titleTextStyleWhite,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Couleur de la flèche retour
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        child: SafeArea(
          child: isLoading == true
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Center(child: CircularProgressIndicator())])
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Consumer<AppState>(builder: (context, state, child) {
                    return Column(children: [
                      const Gap(15.0),
                      Image.asset(
                        logoWhiteNoBg,
                        scale: 2.4,
                        fit: BoxFit.contain,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          showPasswordField == false
                              ? isReset == true
                                  ? "Email"
                                  : 'Vérification'
                              : "Mot de passe",
                          style: subTitleTextStyle,
                        ),
                      ),
                      const Gap(5.0),
                      isReset == true && showPasswordField == false
                          ? CustomTextField(
                              formKey: model.mailFormKey,
                              controller: model.emailCtrl,
                              hintText: "Email",
                              validator: model.validateEmail,
                              onChange: (value) {
                                setState(() {
                                  verifyEmail = false;
                                  showPasswordField = false;
                                });
                              })
                          : Container(),
                      isReset == true && showPasswordField == false
                          ? const Gap(20)
                          : Container(),
                      showPasswordField == true
                          ? CustomTextField(
                              formKey: model.passwordFormKey,
                              controller: model.passwordController,
                              hintText: AppMessages.password,
                              typeInput: TypeInput.password,
                              validator: model.validatePassword,
                              typeOfInput: TypeOfInput.password,
                            )
                          : Container(),
                      showPasswordField == true ? const Gap(20) : Container(),
                      showPasswordField == true
                          ? CustomTextField(
                              formKey: model.passwordConfirmFormKey,
                              controller: model.passwordControllerConfirm,
                              hintText: AppMessages.confirmPassword,
                              typeInput: TypeInput.password,
                              validator: model.validatePasswordConfirm,
                              typeOfInput: TypeOfInput.password,
                            )
                          : Container(),
                      verifyEmail == true
                          ? CustomTextField(
                              formKey: model.tokenFormKey,
                              controller: model.verifyController,
                              hintText: "Code de vérification",
                              validator: model.validateToken,
                              maxLine: 1,
                            )
                          : Container(),
                      showPasswordField || verifyEmail
                          ? const Gap(20.0)
                          : Container(),
                      CustomBtn(
                        textColor: Colors.white,
                        content: "Confirmer",
                        isLoading: model.getState == ViewState.busy,
                        onPress: () {
                          if (verifyEmail == false &&
                              showPasswordField == false &&
                              model.mailFormKey.currentState!.validate()) {
                            model.request(
                                appState: appState,
                                email: model.emailCtrl.text,
                                onVerify: () {
                                  setState(() {
                                    verifyEmail = true;
                                  });
                                });
                          } else if (verifyEmail == true &&
                              showPasswordField == false &&
                              model.tokenFormKey.currentState!.validate()) {
                            model.verify(
                                appState: appState,
                                email: model.emailCtrl.text,
                                token: model.verifyController.text,
                                onVerify: () {
                                  setState(() {
                                    verifyEmail = false;
                                    showPasswordField = true;
                                  });
                                });
                          } else if (verifyEmail == false &&
                              showPasswordField == true &&
                              model.passwordFormKey.currentState!.validate() &&
                              model.passwordConfirmFormKey.currentState!
                                  .validate()) {
                            model.changePassword(
                              appState: appState,
                              email: model.emailCtrl.text,
                              token: model.verifyController.text,
                              password: model.passwordController.text,
                            );
                          }
                        },
                      ),
                    ]);
                  }),
                ),
        ),
      );
    });
  }
}
