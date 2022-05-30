import 'package:flutter/material.dart';
import 'package:todoo/screens/Homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:  ThemeData(fontFamily: 'CircularF',),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: HomePage()
        ),
    );    
  }
}
