// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

Future<List<String>> loadSearchTerms() async {
  final String response = await rootBundle
      .loadString('assets/jsons/bets.json'); //change to api or different json
  final jsonData = await json.decode(response)['bets'];
  List<String> searchTerms = [];
  for (var bet in jsonData) {
    searchTerms.add(bet['name']);
  }
  return searchTerms;
}

Future<List<dynamic>> loadBetData() async {
  final String response =
      await rootBundle.loadString('assets/jsons/betdetails.json');
  var jsonFile = json.decode(response);
  List<dynamic> jsonData = [jsonFile['id']];
  jsonData.add(jsonFile['title']);
  jsonData.add(jsonFile['name']);
  jsonData.add(jsonFile['date']);
  jsonData.add(jsonFile['pool']);
  jsonData.add(jsonFile['playersnum']);
  jsonData.add(jsonFile['optionsnum']);
  for (var option in jsonFile['options']) {
    jsonData.add([option['name'], option['votes'], option['money']]);
  }
  jsonData.add(jsonFile['optionsnum']);
  return jsonData;
}

String font() {
  return 'Poppins';
}
