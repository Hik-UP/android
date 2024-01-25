import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return BaseView<LoginPageViewModel>(
      builder: (context, model, child) => ScaffoldWithCustomBg(
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
                            ),
                            const Gap(20),
                            CustomTextField(
                              controller: model.passwordController,
                              hintText: AppMessages.password,
                              typeInput: TypeInput.password,
                              validator: model.validatePassword,
                              typeOfInput: TypeOfInput.password,
                              maxLine: 1,
                            ),
                            const Gap(20),
                            verifyEmail == true
                                ? CustomTextField(
                                    controller: model.verifyController,
                                    hintText: "Code de vérification",
                                    typeInput: TypeInput.password,
                                    validator: model.validateToken,
                                    typeOfInput: TypeOfInput.password,
                                    maxLine: 1,
                                  )
                                : Container(),
                            verifyEmail ? const Gap(20) : Container(),
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
      ),
    );
  }
}
