import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<List<List<String>>> loadAccountdata() async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  //print("Read Data from loadAccountData is: $jsonFile");
  final names = await jsonFile['stacknames'];
  // //print(jsonFile);
  List<List<String>> stackData = [];
  for (String name in names) {
    // //print("Name is $name");
    //print('''jsonFile["stacks"]["$name"]["name"]''');
    //print(jsonFile["stacks"]["$name"]["name"]);
    stackData.add([
      jsonFile["stacks"]["$name"]["name"],
      jsonFile["stacks"]["$name"]["description"],
      jsonFile["stacks"]["$name"]["type"]
    ]);
  }
  //print("StackData being returned is: $stackData");
  return stackData;
}

Future<List<String>> loadStackData(String name) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  //print("Read Data from loadStackData is: $jsonFile");
  List<String> jsonData = [...(jsonFile["stacks"][name]["items"])];
  //print(jsonData);
  return jsonData;
}

Future<List<String>> loadStackNames() async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  //print("Read Data from loadStackData is: $jsonFile");
  List<String> jsonData = [...(jsonFile["stacknames"])];
  //print(jsonData);
  return jsonData;
}

void saveStackData(String name, List<String>? data) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  //print("Current Itemlist is ${jsonFile["stacks"][name]["items"]}");
  //print("Provided List is: $data");
  jsonFile["stacks"][name]["items"] = data;
  writeJsonToFile(jsonFile);
  //print("Provided Data is: $jsonFile");
}

Future<void> removeStack(String name) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  jsonFile["stacknames"].remove(name);
  jsonFile["stacks"].remove(name);
  writeJsonToFile(jsonFile);
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

  //print("File Data: ${await file.readAsString()}");
}

Future<void> createNewStack(
    String name, String description, String type) async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  jsonFile["stacknames"].add(name);
  jsonFile["stacks"][name] = {
    "name": name,
    "description": description,
    "items": [],
    "type": type
  };
  writeJsonToFile(jsonFile);
}

String baseurl = "";
String uploadurl = "";
String downloadurl = "";

Future<void> uploadAudio() async {
  final path =
      await getApplicationDocumentsDirectory().then((value) => value.path);
  final File file = File('$path/myFile.m4a');
  final bytes = await file.readAsBytes();
  print("Uploading Audio");
  final response = await http.post(Uri.parse(baseurl + uploadurl), body: bytes);
  //print(response.body);
}

Future<List<String>> getList() async {
  // final response = await http.get(Uri.parse(baseurl+downloadurl));
  print("Getting List");
  return ["Item1", "Item2", "Item3", "Item4", "Yooooo works!!!"];
}
