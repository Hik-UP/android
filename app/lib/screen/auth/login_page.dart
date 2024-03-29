import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/providers/sound_state.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/login_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/auth/reset_page.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginButtonError = false;
  bool verifyEmail = false;
  String loginButtonText = "Login";

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginPageViewModel>(builder: (context, model, child) {
      void startTimer(int start) {
        model.delay = start;
        const oneSec = Duration(seconds: 1);
        model.timer = Timer.periodic(
          oneSec,
          (Timer timer) {
            if (model.delay == 0) {
              setState(() {
                timer.cancel();
              });
            } else {
              setState(() {
                model.delay = model.delay - 1;
              });
            }
          },
        );
      }

      return ScaffoldWithCustomBg(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    Form(
                      key: model.loginFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              controller: model.emailController,
                              hintText: AppMessages.email,
                              validator: model.validateEmail,
                              onChange: (value) {
                                if (model.timer != null) {
                                  model.timer?.cancel();
                                  model.delay = 0;
                                }
                                model.verifyController.text = '';
                                if (verifyEmail == true) {
                                  setState(() {
                                    verifyEmail = false;
                                  });
                                }
                              },
                            ),
                            const Gap(20),
                            CustomTextField(
                              controller: model.passwordController,
                              hintText: AppMessages.password,
                              typeInput: TypeInput.password,
                              validator: model.validatePassword,
                              typeOfInput: TypeOfInput.password,
                              maxLine: 1,
                              onChange: (value) {
                                model.verifyController.text = '';
                                if (verifyEmail == true) {
                                  setState(() {
                                    verifyEmail = false;
                                  });
                                }
                              },
                            ),
                            verifyEmail == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                          child: CustomBtn(
                                              bgColor: Colors.transparent,
                                              borderColor: Colors.transparent,
                                              textColor: Colors.white,
                                              isLoading: model.getState ==
                                                  ViewState.update,
                                              disabled: model.getState ==
                                                  ViewState.deletion,
                                              onPress: () =>
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    ResetPage.routeName,
                                                  ),
                                              content: "Mot de passe oublié")),
                                    ],
                                  )
                                : Container(),
                            verifyEmail == false ? const Gap(5) : const Gap(20),
                            verifyEmail == true
                                ? CustomTextField(
                                    controller: model.verifyController,
                                    hintText: "Code de vérification",
                                    validator: model.validateToken,
                                    maxLine: 1,
                                  )
                                : Container(),
                            verifyEmail == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                          child: CustomBtn(
                                              bgColor: Colors.transparent,
                                              borderColor: Colors.transparent,
                                              textColor: Colors.white,
                                              isLoading: model.getState ==
                                                  ViewState.resend,
                                              disabled: model.getState ==
                                                      ViewState.busy ||
                                                  model.delay != 0,
                                              onPress: () => model.resend(
                                                  email: model
                                                      .emailController.text,
                                                  onDelay: (delay) {
                                                    startTimer(delay);
                                                  }),
                                              content: model.delay == 0
                                                  ? "Renvoyer un code"
                                                  : "Renvoyer un code (${model.delay})")),
                                    ],
                                  )
                                : Container(),
                            verifyEmail ? const Gap(5) : Container(),
                            CustomBtn(
                              textColor: Colors.white,
                              content: AppMessages.login,
                              isLoading: model.getState == ViewState.busy,
                              onPress: () {
                                context.read<SoundState>().playAudio(
                                    soundSource: 'sounds/NormalClick.mp3');
                                if (model.loginFormKey.currentState!
                                    .validate()) {
                                  if (verifyEmail == true) {
                                    model.verify(
                                      email: model.emailController.text,
                                      password: model.passwordController.text,
                                      token: model.verifyController.text,
                                      appState: context.read<AppState>(),
                                    );
                                  } else {
                                    model.login(
                                      email: model.emailController.text,
                                      password: model.passwordController.text,
                                      onVerify: () {
                                        setState(() {
                                          verifyEmail = true;
                                        });
                                      },
                                      appState: context.read<AppState>(),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 23, 255, 119),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                      },
                      child: Text(
                        "Je n'ai pas encore de compte",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
