// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

class AudioPage extends StatefulWidget {
  AudioPage({Key? key, required this.wordList}) : super(key: key);

  List<String> wordList;

  @override
  _AudioPageState createState() => _AudioPageState(wordList: wordList);
}

class _AudioPageState extends State<AudioPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  List<String> wordList;
  bool _stop = false;

  _AudioPageState({required this.wordList});

  @override
  void initState() {
    super.initState();
    _initSpeech();
    //_startListening();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 5),
      );
      print("Value of _stop is $_stop");
      if (_stop) timer.cancel();
    });
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    _stop = true;
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if (result.finalResult) {
        wordList.add(result.recognizedWords);
      }
      _stopListening();
    });
    print(wordList);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening
                    ? wordList.lastOrNull ?? "No Words Yet"
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
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic))
        ],
      ),
    );
  }
}
