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
      body: Container(
        child: Center(
          child: Text(
            "MayMay",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
