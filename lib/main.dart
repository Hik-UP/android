import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hik_up/pages/ProfilePage.dart';
import 'package:hik_up/pages/SocialPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hik_up/pages/LoginPage.dart';
import 'package:hik_up/pages/MapPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hik\'Up',
      home: BodyController(),
    );
  }
}

Future<String?> getToken() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

class BodyController extends StatefulWidget {
  const BodyController({Key? key}) : super(key: key);
  @override
  BodyControllerState createState() => BodyControllerState();
}

class BodyControllerState extends State<BodyController> {
  int _navbarIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      switch (_navbarIndex) {
        case 0:
          return const SocialPage();
        case 1:
          return const MapPage();
        case 2:
          return const ProfilePage();
        default:
          return const LoginPage();
      }
    }

    getToken().then((token) => {
          if (token == null)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              )
            }
        });

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ])),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromRGBO(255, 255, 255, 0.3),
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.people,
                text: 'Social',
              ),
              GButton(
                icon: Icons.map,
                text: 'Map',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              )
            ],
            selectedIndex: _navbarIndex,
            onTabChange: (index) {
              setState(() {
                _navbarIndex = index;
              });
            },
          ),
        ),
      ),
      body: getBody(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
