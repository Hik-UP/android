import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/viewmodel/login_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginButtonError = false;
  String loginButtonText = "Login";

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginPageViewModel>(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
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
                                margin: const EdgeInsets.only(top: 170)),
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
                                  controller: model.emailController,
                                  hintText: AppMessages.email,
                                  validator: Validation.validEmail,
                                ),
                                const Gap(10),
                                CustomTextField(
                                  controller: model.passwordController,
                                  hintText: AppMessages.password,
                                  typeInput: TypeInput.password,
                                  validator: model.validPassword,
                                  typeOfInput: TypeOfInput.password,
                                ),
                                const Gap(10),
                                CustomBtn(
                                  content: AppMessages.login,
                                  isLoading: model.getState == ViewState.busy,
                                  onPress: () {
                                    if (model.loginFormKey.currentState!
                                        .validate()) {
                                      model.login(
                                        email: model.emailController.text,
                                        password: model.passwordController.text,
                                        appState: context.read<AppState>(),
                                      );
                                    }
                                  },
                                  gradient: loginButtonColor,
                                ),
                                const Gap(2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 23, 255, 119),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ));
                                      },
                                      child: Text(
                                        AppMessages.noAccountYet,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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
