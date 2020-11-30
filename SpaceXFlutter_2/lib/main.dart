import 'package:flutter/material.dart';
import 'LaunchList.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LaunchList(),
    );
  }
}

