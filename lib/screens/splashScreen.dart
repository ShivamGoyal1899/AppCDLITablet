import 'dart:async';

import 'package:flutter/material.dart';

import 'horizontalCarousel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _alignment = Alignment.bottomCenter;

  @override
  initState() {
    super.initState();
    Timer(Duration(milliseconds: 10), animate);
  }

  Future<Timer> loadTimer() async {
    return Timer(Duration(milliseconds: 500), navigate);
  }

  navigate() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HorizontalCarousel(title: 'CDLI tablet', index: 0)));
  }

  animate() {
    setState(() {
      _alignment = Alignment.center;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: FadeInImage(
              placeholder: AssetImage('assets/images/fade.jpg'),
              image: AssetImage('assets/images/splash_bg.png'),
              fadeInDuration: Duration(milliseconds: 300),
              fit: BoxFit.cover,
            ),
          ),
          AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 80),
            duration: Duration(milliseconds: 1000),
            alignment: _alignment,
            child: Image.asset('assets/images/logo.png'),
            onEnd: loadTimer,
          ),
        ],
      ),
    );
  }
}
