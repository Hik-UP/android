import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/viewmodel/register_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/custom_btn.dart';
//import 'package:hik_up/api/api.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = "/register";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool registerButtonError = false;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    var _i18n = AppLocalizations.of(context)!;

    return BaseView<RegisterPageViewModel>(
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 114, 18, 18),
          body: Center(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    homeBackgroundDay,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    const Gap(15.0),
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(logoWhiteNoBg),
                              scale: 2,
                              fit: BoxFit.contain)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                                margin: const EdgeInsets.only(top: 165)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // 50% de la largeur de l'écran
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Form(
                          key: model.loginFormKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                CustomTextField(
                                  hintText: _i18n.usernameHintText,
                                  controller: model.usernameController,
                                  validator: Validation.validateUsername,
                                ),
                                const Gap(10.0),
                                CustomTextField(
                                  controller: model.emailController,
                                  hintText: _i18n.email,
                                  validator: model.validateEmail,
                                ),
                                const Gap(10.0),
                                CustomTextField(
                                  controller: model.passwordController,
                                  hintText: _i18n.password,
                                  typeInput: TypeInput.password,
                                  validator: model.validatePassword,
                                  typeOfInput: TypeOfInput.password,
                                ),
                                const Gap(10),
                                CustomBtn(
                                  isLoading: model.getState == ViewState.busy,
                                  content: _i18n.registerButtonText,
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
                                const Gap(2.0),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 23, 255, 119),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          LoginPage.routeName,
                                        );
                                      },
                                      child: Text(
                                        _i18n.alreadyHaveAccount,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
