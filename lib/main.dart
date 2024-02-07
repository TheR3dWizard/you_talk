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


// home: FutureBuilder<List<String>>(
//         future: loadStackData(), // asynchronous function call
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, build the widget with the data
//             return StackPage(itemList: snapshot.data);
//           } else {
//             // Otherwise, show a loading indicator or handle the loading state
//             return const CircularProgressIndicator();
//           }
//         },
//       ),