import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result.dart'; // Import the ResultPage

class SpeechAnalysisPage extends StatefulWidget {
  const SpeechAnalysisPage({Key? key}) : super(key: key);

  @override
  State<SpeechAnalysisPage> createState() => _SpeechAnalysisPageState();
}

class _SpeechAnalysisPageState extends State<SpeechAnalysisPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  List<Map<String, dynamic>> _messages = [];
  // This list stores the server responses for later use.
  List<Map<String, dynamic>> _serverResponses = [];

  // Original questions list.
  final List<String> _questions = [
    "What day is it today?",
    "What did you have for breakfast?",
    "What is your favorite color?",
    "Can you name an animal?",
    "What do you usually do in the morning?",
  ];

  // This list holds the available questions for selection.
  late List<String> _availableQuestions;

  late String _currentQuestion;
  int _questionCount = 1;
  final int _maxQuestions = 3;
  bool _finished = false; // Indicates if all questions are completed

  @override
  void initState() {
    super.initState();
    _availableQuestions = List.from(_questions); // copy original questions

    _initRecorder();
    // Ask the first question from _availableQuestions
    _currentQuestion = _getRandomQuestion();
    _messages.add({
      'text': _currentQuestion,
      'isUser': false,
      'isAudio': false,
    });
  }

  // Picks a random question from the available list and removes it.
  String _getRandomQuestion() {
    if (_availableQuestions.isNotEmpty) {
      int index = Random().nextInt(_availableQuestions.length);
      return _availableQuestions.removeAt(index);
    }
    // If none available, fallback to a random question from original list.
    return _questions[Random().nextInt(_questions.length)];
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
              "Microphone permission is required to record audio. Please enable it in your settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }
    await _recorder.openRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!await Permission.microphone.isGranted) return;
    final directory = await Directory.systemTemp.createTemp();
    _filePath =
    '${directory.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    try {
      await _recorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint("Error starting recording: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to start recording: $e")),
      );
    }
  }

  Future<void> _stopRecordingAndSave() async {
    try {
      final path = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File is not uploaded. Check your connection or try again."),
          ),
        );
        return;
      }

      _filePath = path;
      _sendAudioToServer(_filePath!);
    } catch (e) {
      debugPrint("Error stopping recording: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to stop recording: $e")),
      );
    }
  }

  Future<void> _sendAudioToServer(String filePath) async {
    // Show a loading dialog while waiting for the server response.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Please wait..."),
            ],
          ),
        ),
      ),
    );

    try {
      // Add the user's recorded audio to the chat.
      setState(() {
        _messages.add({
          'text': "Recorded Audio",
          'isUser': true,
          'isAudio': true,
        });
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://168.138.69.56:8091/predict'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        String predictedLabel = jsonResponse["predicted_label"] ?? "No label";
        double confidence = jsonResponse["confidence"] != null
            ? jsonResponse["confidence"].toDouble()
            : 0.0;

        // Save the response in _serverResponses without showing it.
        _serverResponses.add({
          'predictedLabel': predictedLabel,
          'confidence': confidence,
        });
      } else {
        _serverResponses.add({
          'error': "Server error: ${response.statusCode}",
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File is not uploaded. Check your connection or try again."),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error uploading file: $e");
      _serverResponses.add({
        'error': "Error: $e",
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File is not uploaded. Check your connection or try again."),
        ),
      );
    } finally {
      Navigator.of(context).pop(); // Dismiss the loading dialog.
      _askNextQuestion();
    }
  }

  void _askNextQuestion() {
    if (_questionCount < _maxQuestions) {
      _questionCount++;
      _currentQuestion = _getRandomQuestion();
      setState(() {
        _messages.add({
          'text': _currentQuestion,
          'isUser': false,
          'isAudio': false,
        });
      });
    } else {
      // Mark as finished and show the Next button.
      setState(() {
        _finished = true;
      });
      debugPrint("All responses saved: $_serverResponses");
    }
  }

  void _goToResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(serverResponses: _serverResponses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech Analysis"),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Column(
        children: [
          // Chat message list shows only questions and user recordings.
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message['isUser'];
                bool isAudio = message['isAudio'];
                String text = message['text'];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.grey[200] : Colors.blue[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isAudio
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.audiotrack),
                        const SizedBox(width: 8),
                        Text(text),
                      ],
                    )
                        : Text(text),
                  ),
                );
              },
            ),
          ),
          // If finished, show the Next button; otherwise, show recording controls.
          _finished
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _goToResultPage,
              child: const Text("Next"),
            ),
          )
              : Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  color: _isRecording ? Colors.red : Colors.blue,
                  onPressed: () {
                    if (_isRecording) {
                      _stopRecordingAndSave();
                    } else {
                      _startRecording();
                    }
                  },
                ),
                const SizedBox(width: 8),
                Text(_isRecording ? "Recording..." : "Tap mic to record"),
                const Spacer(),
                if (_isRecording)
                  ElevatedButton(
                    onPressed: _stopRecordingAndSave,
                    child: const Text("Save"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
