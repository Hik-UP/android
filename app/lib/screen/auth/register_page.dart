import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/custom_text_btn.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/viewmodel/register_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:provider/provider.dart';
import '../../widget/custom_btn.dart';


class RegisterPage extends StatefulWidget {
  static String routeName = "/register";
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool registerButtonError = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<RegisterPageViewModel>(
      builder: (context, model, child) => ScaffoldWithCustomBg(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const Gap(15.0),
                  Image.asset(
                    logoWhiteNoBg,
                    scale: 2.4,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: model.loginFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              hintText: AppMessages.usernameHintText,
                              controller: model.usernameController,
                              validator: Validation.validateUsername,
                            ),
                            const Gap(20.0),
                            CustomTextField(
                              controller: model.emailController,
                              hintText: AppMessages.email,
                              validator: model.validateEmail,
                            ),
                            const Gap(20.0),
                            CustomTextField(
                              controller: model.passwordController,
                              hintText: AppMessages.password,
                              typeInput: TypeInput.password,
                              validator: model.validatePassword,
                              typeOfInput: TypeOfInput.password,
                            ),
                            const Gap(20),
                            CustomTextField(
                              controller: model.passwordControllerConfirm,
                              hintText: AppMessages.confirmPassword,
                              typeInput: TypeInput.password,
                              validator: model.validatePassword,
                              typeOfInput: TypeOfInput.password,
                            ),
                            const Gap(20.0),
                            CustomBtn(
                              isLoading: model.getState == ViewState.busy,
                              content: AppMessages.registerButtonText,
                              bgColor: const Color.fromRGBO(59, 44, 26, 1),
                              borderColor:
                                  const Color.fromRGBO(255, 174, 49, 1),
                              onPress: () {
                                if (model.loginFormKey.currentState!
                                    .validate()) {
                                  model.register(
                                    username: model.usernameController.text,
                                    email: model.emailController.text,
                                    password: model.passwordController.text,
                                    appState: appState,
                                  );
                                }
                              },
                              gradient: loginButtonColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextBtn(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: "Je possède déjà un compte",
                color: const Color.fromRGBO(255, 174, 49, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
