// ignore_for_file: no_logic_in_create_state, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:you_talk/homepagestful.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'youTalk',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePageStful(),
      debugShowCheckedModeBanner: false,
    );
  }
}
