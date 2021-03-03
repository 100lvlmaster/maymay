import 'package:flutter/material.dart';
import 'package:maymay/screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _pushNext();
  }

  _pushNext() => Future.delayed(
      Duration(milliseconds: 400),
      () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          child: Image.asset("assets/icon/logo.png"),
        ),
      ),
    );
  }
}
