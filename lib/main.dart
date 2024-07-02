import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/LoginScreen.dart';
import 'Admin/DashboardAdmin.dart';
import 'Users/Dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: "QurArsApp",
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Function to check login status
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? role = prefs.getString('role');

    // Delay for 3 seconds for splash screen visibility
    await Future.delayed(Duration(seconds: 3));

    if (token == null && role == null) {
      Navigator.of(context).pushAndRemoveUntil(
        _createRoute(LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (role == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        _createRoute(DashboardAdmin()),
        (Route<dynamic> route) => false,
      );
    } else if (role == 1) {
      Navigator.of(context).pushAndRemoveUntil(
        _createRoute(Dashboard()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/splash_screen.png',
              width: 0,
              height: 0,
            ),
            Image.asset(
              'assets/splash_screen.png',
              width: 255,
              height: 255,
            ),
            Container(
                child: Column(
              children: [
                Text(
                  'From',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Image.asset(
                  'assets/splash_screen2.png',
                  width: 160,
                  height: 70,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
