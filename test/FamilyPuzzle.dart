import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

class NextPage extends StatefulWidget {
  final String title;
  final String description;
  final File image;

  const NextPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late List<img.Image> _imagePieces;
  late List<int> _shuffledIndices;
  late List<int?> _centerSlots;
  Set<int> _usedPieces = {};

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';
  String _speechStatus = '';

  bool _speechStartedAfterAllPlaced = false;

  @override
  void initState() {
    super.initState();
    _splitImageIntoPieces();
    _speech = stt.SpeechToText();
  }

  void _splitImageIntoPieces() {
    img.Image originalImage = img.decodeImage(widget.image.readAsBytesSync())!;
    int pieceWidth = originalImage.width ~/ 2;
    int pieceHeight = originalImage.height ~/ 2;

    _imagePieces = [];
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 2; x++) {
        _imagePieces.add(
          img.copyCrop(
            originalImage,
            x: x * pieceWidth,
            y: y * pieceHeight,
            width: pieceWidth,
            height: pieceHeight,
          ),
        );
      }
    }

    _shuffledIndices = List.generate(4, (index) => index)..shuffle();
    _centerSlots = [null, null, null, null];
  }

  bool _allSlotsFilled() {
    return !_centerSlots.contains(null);
  }

  bool _isPuzzleCorrect() {
    for (int i = 0; i < 4; i++) {
      if (_centerSlots[i] != i) {
        return false;
      }
    }
    return true;
  }

  Future<void> _savePerformanceRecord({
    required bool puzzleCompleted,
    required bool puzzleCorrect,
    required bool speechCorrect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getStringList('performance_records') ?? [];

    final newRecord = jsonEncode({
      'puzzleCorrect': true,
      'speechCorrect': false,
      'timestamp': DateTime.now().toIso8601String(),
    });

    records.add(newRecord);
    await prefs.setStringList('performance_records', records);
  }

  Future<void> _updateLastPerformanceSpeechCorrect(bool speechCorrect) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'performance_records';
    List<String> recordsJsonList = prefs.getStringList(key) ?? [];

    if (recordsJsonList.isNotEmpty) {
      var lastRecord = jsonDecode(recordsJsonList.last);
      lastRecord['speechCorrect'] = speechCorrect;
      recordsJsonList[recordsJsonList.length - 1] = jsonEncode(lastRecord);
      await prefs.setStringList(key, recordsJsonList);
    }
  }

  void _onPiecePlaced() async {
    if (_allSlotsFilled()) {
      bool puzzleCorrect = _isPuzzleCorrect();

      // Save puzzle completion correctness per title (optional)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('puzzle_completed_${widget.title}', true);
      await prefs.setBool('puzzle_correct_${widget.title}', puzzleCorrect);

      // Save global record with speechCorrect = false (will update later)
      await _savePerformanceRecord(
        puzzleCompleted: true,
        puzzleCorrect: puzzleCorrect,
        speechCorrect: false,
      );

      if (!_speechStartedAfterAllPlaced) {
        _startListening();
        _speechStartedAfterAllPlaced = true;
      }
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => setState(() => _speechStatus = val),
      onError: (val) => setState(() => _speechStatus = 'Error: $val'),
    );
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = '';
        _speechStatus = 'Listening...';
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _recognizedText = val.recognizedWords;
        });
      });
    } else {
      setState(() {
        _speechStatus = 'Speech recognition not available';
      });
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    _checkSpeechGuess();
  }

  Future<void> _checkSpeechGuess() async {
    bool correctGuess =
        _recognizedText.trim().toLowerCase() == widget.title.toLowerCase();

    // Save per-title correct guess (optional)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('correct_guess_${widget.title}', correctGuess);

    // Update last global record with speech correctness
    await _updateLastPerformanceSpeechCorrect(correctGuess);

    _showResultDialog(correctGuess);
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Try Again'),
        content: Text(isCorrect
            ? 'You correctly identified the puzzle title!'
            : 'Your spoken title did not match. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reassemble the Image'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(widget.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return DragTarget<int>(
                    onWillAccept: (data) => !_centerSlots.contains(data),
                    onAccept: (receivedIndex) {
                      setState(() {
                        if (_centerSlots[index] != null) {
                          _usedPieces.remove(_centerSlots[index]!);
                        }
                        _centerSlots[index] = receivedIndex;
                        _usedPieces.add(receivedIndex);
                      });
                      _onPiecePlaced();
                    },
                    builder: (context, candidateData, rejectedData) {
                      final slotIndex = _centerSlots[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple),
                          color: slotIndex != null
                              ? Colors.deepPurple.shade50
                              : Colors.white,
                        ),
                        child: slotIndex != null
                            ? Image.memory(
                                Uint8List.fromList(
                                  img.encodeJpg(_imagePieces[slotIndex]),
                                ),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                'Drop Here',
                                style: TextStyle(
                                    color: Colors.deepPurple.shade300,
                                    fontWeight: FontWeight.w500),
                              )),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    int shuffledIndex = _shuffledIndices[index];
                    if (_usedPieces.contains(shuffledIndex)) {
                      return SizedBox(width: 100, height: 100);
                    }
                    return Draggable<int>(
                      data: shuffledIndex,
                      feedback: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: MemoryImage(Uint8List.fromList(
                                img.encodeJpg(_imagePieces[shuffledIndex]))),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        color: Colors.grey.withOpacity(0.4),
                        width: 100,
                        height: 100,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: MemoryImage(Uint8List.fromList(
                                img.encodeJpg(_imagePieces[shuffledIndex]))),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_allSlotsFilled()) ...[
              Text(
                'Speak the puzzle title to verify:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                label: Text(_isListening ? 'Listening...' : 'Stop Listening'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: _isListening ? _stopListening : _startListening,
              ),
              SizedBox(height: 10),
              Text(
                _speechStatus.isEmpty ? _recognizedText : _speechStatus,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ] else ...[
              Text(
                'Place all pieces to start speech recognition automatically.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
