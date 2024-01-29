// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    super.key,
    this.info,
  });

  final String? info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 62.5,
      decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black12),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(35, 0, 0, 0),
              blurRadius: 0.5,
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0), // shadow direction: bottom right
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0),
            )
          ]),
      child: Center(
          child: Text(
        info ?? "No Info",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }
}

class LabelledTextField extends StatelessWidget {
  final String label;
  TextEditingController? controller;
  bool? enabled;
  //final Function(String) subFunction;
  LabelledTextField({
    super.key,
    required this.label,
    //required this.subFunction
  });

  LabelledTextField.readable({
    super.key,
    required this.label,
    required this.controller,
  });

  LabelledTextField.offOn({
    super.key,
    required this.label,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gapPadding: 5.0,
          ),
          labelText: label,
        ),
        controller: controller,
        enabled: enabled,
        //onSubmitted: subFunction,
      ),
    );
  }
}

class Bet extends StatefulWidget {
  final String info;
  const Bet({super.key, required this.info});

  @override
  State<Bet> createState() => _BetState(info: info);
}

class _BetState extends State<Bet> {
  String info;

  _BetState({required this.info});
  //TODO add on pressed function

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Container(
          width: 500,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Text(info),
        ));
  }
}

// Custom Functions

//Function to load bet objects from json

Future<List<dynamic>> loadBets() async {
  final String response = await rootBundle.loadString('assets/jsons/bets.json');
  final jsonData = await json.decode(response)['bets'];
  return jsonData;
}

Future<List<List<String>>> loadAccountdata() async {
  final String response = await rootBundle.loadString('assets/account.json');
  var jsonFile = json.decode(response);
  final names = await jsonFile['stacknames'];
  print(names);
  List<List<String>> searchTerms = [];
  for (String name in names) {
    searchTerms.add(
        [jsonFile['stacks'][name]['name'], jsonFile['stacks'][name]['desc']]);
    print("Hello World");
  }
  print(searchTerms);
  return searchTerms;
}

Future<List<String>> loadStackData(String name) async {
  final String response = await rootBundle.loadString('assets/account.json');
  var jsonFile = json.decode(response);
  List<String> jsonData = [...(jsonFile["stacks"][name]["items"])];
  print(jsonData);
  return jsonData;
}

String font() {
  return 'Poppins';
}
