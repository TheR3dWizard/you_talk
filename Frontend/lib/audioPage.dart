// ignore_for_file: file_names
import 'dart:io';

import 'package:you_talk/utilities/customWidgets.dart';
import 'package:you_talk/utilities/customFunctions.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key? key,required this.list}) : super(key: key);

  List<String> list = [];

  @override
  _AudioPageState createState() => _AudioPageState(list: this.list);
}

class _AudioPageState extends State<AudioPage> {
  
  _AudioPageState({required this.list});
  List<String> list = [];

  final record = AudioRecorder();

  @override
  void initState() {
    super.initState();
  }

  bool _isRecording = false;

  void _toggleRecording() async {
    if (_isRecording) {
      await record.stop();
      await uploadAudio();
      await getList();
    } else {
      _startListening();
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _startListening() async {

    final path = await getApplicationDocumentsDirectory().then((value) => value.path); 
    final File file = File('$path/myFile.m4a');
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(), path: file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            ValueListenableBuilder<bool>(
            valueListenable: ValueNotifier(_isRecording),
            builder: (context, isRecording, child) {
              return ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
              );
            },
            )
        ],
      ),
    );
  }
}
