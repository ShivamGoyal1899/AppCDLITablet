import 'package:cdlitablet/screens/horizontalCarousel.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CDLI Tablet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
        fontFamily: "GoogleSans",
      ),
      home: HorizontalCarousel(title: 'CDLI tablet'),
    );
  }
}
