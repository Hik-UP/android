import 'package:flutter/material.dart';
import 'package:hik_up/api/api.dart';
import 'package:hik_up/main.dart';
import 'package:hik_up/pages/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool loginButtonError = false;
  String loginButtonText = "Login";
  dynamic loginButtonColor = const LinearGradient(colors: [
    Color.fromRGBO(143, 148, 251, 1),
    Color.fromRGBO(143, 148, 251, .6),
  ]);
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailValidator(String email) {
      return (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email));
    }

    passwordValidator(String password) {
      if (password.length < 8) {
        return (false);
      }
      return (true);
    }

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/LoginPage/images/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
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
                        key: loginFormKey,
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
                                controller: emailController,
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
                                    const Color.fromRGBO(143, 148, 251, 1),
                                validator: (String? email) {
                                  if (email != null) {
                                    return (!emailValidator(email)
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
                                controller: passwordController,
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
                                    const Color.fromRGBO(143, 148, 251, 1),
                                validator: (String? password) {
                                  if (password != null) {
                                    return (!passwordValidator(password)
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
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: loginButtonColor),
                    child: ElevatedButton(
                        onPressed: () {
                          if (loginFormKey.currentState!.validate()) {
                            API()
                                .login(emailController.text,
                                    passwordController.text)
                                .then((response) {
                              if (response != null &&
                                  response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()),
                                );
                              } else if (response != null) {
                                setState(() {
                                  setLoginButtonError("Error: Email/Password");
                                });
                              } else {
                                setState(() {
                                  setLoginButtonError(
                                      "Error: Server unavailable");
                                });
                              }
                            });
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
                    height: 70,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(143, 148, 251, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text("No account? Create one!"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
