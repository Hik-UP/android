import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/login_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';

import '../../utils/validation.dart';


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
    

    resetLoginButton() {
      loginButtonError = false;
      loginButtonText = "Login";
      loginButtonColor = const LinearGradient(colors: [
        Color.fromRGBO(143, 148, 251, 1),
        Color.fromRGBO(143, 148, 251, .6),
      ]);
    }

    setLoginButtonError(String message) {
      loginButtonError = true;
      loginButtonText = message;
      loginButtonColor = const LinearGradient(colors: [
        Color.fromRGBO(255, 51, 51, 1),
        Color.fromRGBO(255, 51, 51, .6),
      ]);
    }

    return BaseView<LoginPageViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
             
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage(logoBlackNoBg),
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
                        TypewriterAnimatedText('HikUp!',
                          textStyle: const TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w500,
                      ),
                      speed: const Duration(
                        milliseconds: 450,
                      )),
                ],
                onTap: () {
                  debugPrint("Welcome back!");
                },
                isRepeatingAnimation: true,
                totalRepeatCount: 2,
              ),
                  Container(
                    height: 140,
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
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromRGBO(
                                              245, 245, 245, 1)))),
                              child: TextFormField(
                                key: const Key('emailKey'),
                                controller: model.emailController,
                                onTap: loginButtonError
                                    ? () {
                                        setState(() {
                                          resetLoginButton();
                                        });
                                      }
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                cursorColor:
                                   const Color.fromARGB(255, 0, 189, 41),
                                validator: (String? email) {
                                  if (email != null) {
                                    return (!Validation.emailValidator(email)
                                        ? "This is not a valid email address."
                                        : null);
                                  }
                                  return (null);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: const Key('passwordKey'),
                                controller: model.passwordController,
                                onTap: loginButtonError
                                    ? () {
                                        setState(() {
                                          resetLoginButton();
                                        });
                                      }
                                    : null,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                cursorColor:
                                    Color.fromARGB(255, 0, 189, 41),
                                    //Color.fromARGB(255, 0, 189, 41),
                                   // const Color.fromRGBO(255, 0, 189, 41),
                                validator: (String? password) {
                                  if (password != null) {
                                    return (!Validation.passwordValidator(password)
                                        ? "Password must be at least 8 characters in length."
                                        : null);
                                  }
                                  return (null);
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: loginButtonColor),
                    child: ElevatedButton(
                        onPressed: () {
                          if (model.loginFormKey.currentState!.validate()) {
                            // API()
                            //     .login(emailController.text,
                            //         passwordController.text)
                            //     .then((response) {
                            //   if (response != null &&
                            //       response.statusCode == 200) {
                            //     // Navigator.push(
                            //     //   context,
                            //     //   MaterialPageRoute(
                            //     //       builder: (context) => const MyApp()),
                            //     // );
                            //   } else if (response != null) {
                            //     setState(() {
                            //       setLoginButtonError("Error: Email/Password");
                            //     });
                            //   } else {
                            //     setState(() {
                            //       setLoginButtonError(
                            //           "Error: Server unavailable");
                            //     });
                            //   }
                            // });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            loginButtonText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 179, 60),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterPage.routeName);
                    },
                    child: const Text("No account? Create one!"),
                  ),
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

