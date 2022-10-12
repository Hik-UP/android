import 'package:flutter/material.dart';
import 'package:hik_up/api/api.dart';
import 'package:hik_up/pages/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool registerButtonError = false;
  String registerButtonText = "Register";
  dynamic registerButtonColor = const LinearGradient(colors: [
    Color.fromRGBO(143, 148, 251, 1),
    Color.fromRGBO(143, 148, 251, .6),
  ]);
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usernameValidator(String username) {
      return (RegExp(
              r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")
          .hasMatch(username));
    }

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

    resetRegisterButton() {
      registerButtonError = false;
      registerButtonText = "Login";
      registerButtonColor = const LinearGradient(colors: [
        Color.fromRGBO(143, 148, 251, 1),
        Color.fromRGBO(143, 148, 251, .6),
      ]);
    }

    setRegisterButtonError(String message) {
      registerButtonError = true;
      registerButtonText = message;
      registerButtonColor = const LinearGradient(colors: [
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
              height: 335,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/RegisterPage/images/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 115),
                      child: const Center(
                        child: Text(
                          "Register",
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
                                key: const Key('usernameKey'),
                                controller: usernameController,
                                onTap: registerButtonError
                                    ? () {
                                        setState(() {
                                          resetRegisterButton();
                                        });
                                      }
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                cursorColor:
                                    const Color.fromRGBO(143, 148, 251, 1),
                                validator: (String? username) {
                                  if (username != null) {
                                    return (!usernameValidator(username)
                                        ? "This is not a valid username."
                                        : null);
                                  }
                                  return (null);
                                },
                              ),
                            ),
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
                                onTap: registerButtonError
                                    ? () {
                                        setState(() {
                                          resetRegisterButton();
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
                        gradient: registerButtonColor),
                    child: ElevatedButton(
                        onPressed: () {
                          if (loginFormKey.currentState!.validate()) {
                            API()
                                .register(
                                    usernameController.text,
                                    emailController.text,
                                    passwordController.text)
                                .then((response) {
                              if (response != null &&
                                  response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              } else if (response != null) {
                                setState(() {
                                  setRegisterButtonError(
                                      "Error: Username/Email");
                                });
                              } else {
                                setState(() {
                                  setRegisterButtonError(
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
                            registerButtonText,
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
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text("Already have an account? Sign in!"),
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
