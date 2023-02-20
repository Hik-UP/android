import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(logoBlackNoBg),
                              fit: BoxFit.fill)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              margin: const EdgeInsets.only(top: 190),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'HikUp!',
                                textStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w500,
                                ),
                                speed: const Duration(
                                  milliseconds: 450,
                                ),
                              ),
                            ],
                            onTap: () {
                              debugPrint("Welcome back!");
                            },
                            isRepeatingAnimation: true,
                            totalRepeatCount: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: model.loginFormKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    CustomTextField(
                                      controller: model.emailController,
                                      hintText: AppMessages.email,
                                      validator: model.validEmail,
                                    ),
                                    const Gap(20.0),
                                    CustomTextField(
                                      controller: model.passwordController,
                                      hintText: AppMessages.password,
                                      typeInput: TypeInput.password,
                                      validator: model.validPassword,
                                    ),
                                    const Gap(40),
                                    CustomBtn(
                                      content: AppMessages.login,
                                      isLoading:
                                          model.getState == ViewState.busy,
                                      onPress: () {
                                        if (model.loginFormKey.currentState!
                                            .validate()) {
                                          model.login(
                                            email: model.emailController.text,
                                            password:
                                                model.passwordController.text,
                                            appState: context.read<AppState>(),
                                          );
                                        }
                                      },
                                      gradient: loginButtonColor,
                                    ),
                                    const Gap(20.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color.fromARGB(
                                              255,
                                              0,
                                              179,
                                              60,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              RegisterPage.routeName,
                                            );
                                          },
                                          child: const Text(
                                            "No account? Create one!",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
