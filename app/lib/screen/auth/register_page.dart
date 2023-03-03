import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/register_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

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

    return BaseView<RegisterPageViewModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(logoBlackNoBg), fit: BoxFit.fill),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 210),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 189, 41),
                                fontSize: 40,
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
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Form(
                          key: model.loginFormKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                CustomTextField(
                                  hintText: AppMessages.usernameHintText,
                                  controller: model.usernameController,
                                  validator: model.validateUsername,
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
                                const Gap(40),
                                CustomBtn(
                                  isLoading: model.getState == ViewState.busy,
                                  content: AppMessages.registerButtonText,
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
                                const Gap(20.0),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          const Color.fromARGB(255, 0, 179, 60),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LoginPage.routeName);
                                    },
                                    child: const Text(
                                      "Already have an account? Sign in!",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
