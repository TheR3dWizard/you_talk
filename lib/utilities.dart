// ignore_for_file: must_be_immutable
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

Future<List<List<String>>> loadAccountdata() async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  print("Read Data from loadAccountData is: $jsonFile");
  final names = await jsonFile['stacknames'];
  // print(jsonFile);
  List<List<String>> stackData = [];
  for (String name in names) {
    // print("Name is $name");
    print('''jsonFile["stacks"]["$name"]["name"]''');
    print(jsonFile["stacks"]["$name"]["name"]);
    stackData.add([
      jsonFile["stacks"]["$name"]["name"],
      jsonFile["stacks"]["$name"]["description"]
    ]);
  }
  print(stackData);
  return stackData;
}

Future<List<String>> loadStackData(String name) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  print("Read Data from loadStackData is: $jsonFile");
  List<String> jsonData = [...(jsonFile["stacks"][name]["items"])];
  print(jsonData);
  return jsonData;
}

void saveStackData(String name, List<String>? data) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  print("Current Itemlist is ${jsonFile["stacks"][name]["items"]}");
  print("Provided List is: $data");
  jsonFile["stacks"][name]["items"] = data;
  writeJsonToFile(jsonFile);
  print("Provided Data is: $jsonFile");
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;

  File file = File('$path/account.json');
  if (!file.existsSync()) {
    await file.create(exclusive: false);
    String jsonString = await rootBundle.loadString('assets/account.json');
    await file.writeAsString(jsonString);
  }

  return file;
}

void writeJsonToFile(Map<String, dynamic> data) async {
  final file = await _localFile;

  // Convert the data to a JSON string
  String jsonString = json.encode(data);

  // Write the JSON string to the file
  await file.writeAsString(jsonString);

  print("File Data: ${await file.readAsString()}");
}

void createNewStack(String name, String description) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  jsonFile["stacknames"].add(name);
  jsonFile["stacks"]
      [name] = {"name": name, "description": description, "items": []};
  writeJsonToFile(jsonFile);
}
