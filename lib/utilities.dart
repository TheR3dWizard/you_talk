// ignore_for_file: must_be_immutable
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

class AudioPage extends StatefulWidget {
  AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recognized words:',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening
                    ? '$_lastWords'
                    // If listening isn't active but could be tell the user
                    // how to start it, otherwise indicate that speech
                    // recognition is not yet ready or not supported on
                    // the target device
                    : _speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
              ),
            ),
          ),
          OutlinedButton(
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic)),
        ],
      ),
    );
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
  print("StackData being returned is: $stackData");
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

Future<List<String>> loadStackNames() async {
  final File file = await _localFile;
  final String response = await file.readAsString();
  var jsonFile = json.decode(response);
  print("Read Data from loadStackData is: $jsonFile");
  List<String> jsonData = [...(jsonFile["stacknames"])];
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

void removeStack(String name) async {
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
