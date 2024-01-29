import 'package:flutter/material.dart';
import 'package:you_talk/utilities.dart';
import 'package:you_talk/stackPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('youTalk'),
      ),
      body: FutureBuilder(
          future: loadAccountdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, build the widget with the data
              return StackIntro(
                  data: snapshot.data?[0] ?? ["No Info", "No Info"]);
            } else {
              // Otherwise, show a loading indicator or handle the loading state
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

class StackIntro extends StatelessWidget {
  const StackIntro({super.key, required this.data});

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FutureBuilder<List<String>>(
              future: loadStackData("stack1"), // asynchronous function call
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, build the widget with the data
                  return StackPage(itemList: snapshot.data);
                } else {
                  // Otherwise, show a loading indicator or handle the loading state
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.blue,
            ),
            constraints: const BoxConstraints(
                minHeight: 50, minWidth: 50, maxWidth: 100, maxHeight: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[0],
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data[1]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
