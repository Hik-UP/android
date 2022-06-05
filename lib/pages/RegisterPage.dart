import 'package:flutter/material.dart';
import 'package:hik_up/pages/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    usernameValidator(String username) {
      return (RegExp(r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$").hasMatch(username));
    }

    emailValidator(String email) {
      return (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email));
    }

    passwordValidator(String password) {
      if (password.length < 8) {
        return (false);
      }
      return (true);
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
                  image: AssetImage('assets/RegisterPage/images/background.png'),
                  fit: BoxFit.fill
                )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 115),
                      child: const Center(
                        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
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
                          offset: Offset(0, 10)
                        )
                      ]
                    ),
                    child: Form(
                      key: loginFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color.fromRGBO(245, 245, 245, 1)))
                            ),
                            child: TextFormField(
                              key: const Key('usernameKey'),
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              validator: (String? username) {
                                if (username != null) {
                                  return (!usernameValidator(username) ? "This is not a valid username.": null);
                                }
                                return (null);
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color.fromRGBO(245, 245, 245, 1)))
                            ),
                            child: TextFormField(
                              key: const Key('emailKey'),
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              validator: (String? email) {
                                if (email != null) {
                                  return (!emailValidator(email) ? "This is not a valid email address.": null);
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
                                hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              validator: (String? password) {
                                if (password != null) {
                                  return (!passwordValidator(password) ? "Password must be at least 8 characters in length.": null);
                                }
                                return (null);
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ]
                      )
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (loginFormKey.currentState!.validate()) {
                          print('username: ' + usernameController.text);
                          print('email: ' + emailController.text);
                          print('password: ' + passwordController.text);
                        }
                        else {
                          print("invalid input detected !");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Center(
                        child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      )
                    ),
                  ),
                  const SizedBox(height: 70,),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary:const Color.fromRGBO(143, 148, 251, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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