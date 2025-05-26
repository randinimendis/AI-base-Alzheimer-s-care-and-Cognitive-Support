// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:typed_data';
// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:flutter_drawing_board/flutter_drawing_board.dart';
// // // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:http/http.dart' as http;
// // import '../data.dart';
// //
// // class Drawingactivity extends StatefulWidget {
// //   const Drawingactivity({super.key});
// //
// //   @override
// //   State<Drawingactivity> createState() => _DrawingactivityState();
// // }
// //
// // class _DrawingactivityState extends State<Drawingactivity> {
// //   final DrawingController _drawingController = DrawingController();
// //   // late Interpreter _interpreter;
// //   // List<Map<String, dynamic>> predictions = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // _loadModel();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _drawingController.dispose();
// //     // _interpreter.close();
// //     super.dispose();
// //   }
// //
// //   // Future<void> _loadModel() async {
// //   //   _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
// //   // }
// //
// //   Future<void> _submitDrawing() async {
// //     // Get the image data from the drawing controller as a PNG image
// //     final ByteData? byteData = await _drawingController.getImageData();
// //     if (byteData == null) return;
// //
// //     // Convert ByteData to Uint8List (PNG)
// //     final Uint8List uint8List = byteData.buffer.asUint8List();
// //
// //     // Prepare data to send (image in PNG format)
// //     final FormData formData = FormData.fromMap({
// //       "image": MultipartFile.fromBytes(uint8List, filename: 'drawing.png'),
// //     });
// //
// //     try {
// //       final dio = Dio();
// //       final response = await dio.post(
// //         'http://172.20.10.13:5010/transform', // Your Flask server endpoint
// //         data: formData,
// //       );
// //
// //       if (response.statusCode == 200) {
// //         print('Image successfully uploaded: ${response.data}');
// //       } else {
// //         print('Failed with status code: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }
// //
// //   // Future<void> _submitDrawing() async {
// //   //   final ByteData? byteData = await _drawingController.getImageData();
// //   //   if (byteData == null) return;
// //   //   final Uint8List rawImage = byteData.buffer.asUint8List();
// //   //   if (rawImage == null) {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       const SnackBar(content: Text('Error getting drawing!')),
// //   //     );
// //   //     return;
// //   //   }
// //   //
// //   //   // Convert raw image data to Image object
// //   //   img.Image? image = img.decodeImage(rawImage);
// //   //   if (image == null) return;
// //   //
// //   //   // Convert to grayscale, resize to 28x28, and remove background
// //   //   img.Image processedImage = _preprocessImage(image);
// //   //
// //   //   ImageProcessor imageProcessor = ImageProcessorBuilder()
// //   //       .add(ResizeOp(28, 28, ResizeMethod.NEAREST_NEIGHBOUR))
// //   //       .build();
// //   //
// //   //   TensorImage tensorImage = TensorImage.fromFile(image as File);
// //   //
// //   //   var input = imageProcessor.process(tensorImage);
// //   //
// //   //   // Convert to Float32 tensor for TFLite model
// //   //   var input = _imageToTensor(processedImage);
// //   //
// //   //
// //   //   // Run inference
// //   //   var output = List.filled(345, 0.0).reshape([1, 345]); // Adjust for your model
// //   //   _interpreter.run(input, output);
// //   //
// //   //   // Process and display predictions
// //   //   _processPredictions(output[0]);
// //   // }
// //
// //   // img.Image _preprocessImage(img.Image image) {
// //   //   // Convert to grayscale
// //   //   image = img.grayscale(image);
// //   //
// //   //   // Resize to 28x28
// //   //   image = img.copyResize(image, width: 28, height: 28);
// //   //
// //   //   // Remove white background
// //   //   for (int y = 0; y < image.height; y++) {
// //   //     for (int x = 0; x < image.width; x++) {
// //   //       // Get the pixel color as a Pixel object
// //   //       int pixel = image.getPixel(x, y);
// //   //
// //   //       if (pixel == 0xFFFFFFFF) {  // If white (0xFFFFFFFF is white in ARGB format)
// //   //         // Set pixel to transparent (0x00000000 is transparent in ARGB format)
// //   //         image.setPixel(x, y, 0);
// //   //       }
// //   //     }
// //   //   }
// //   //
// //   //   return image;
// //   // }
// //
// //   //
// //   // List<List<List<List<double>>>> _imageToTensor(img.Image image) {
// //   //   // Create a 28x28 tensor with the pixel values normalized to [0, 1]
// //   //   List<List<List<double>>> tensor = List.generate(28, (y) {
// //   //     return List.generate(28, (x) {
// //   //       // Get the pixel color as an integer (ARGB format)
// //   //       int pixel = image.getPixel(x, y);
// //   //
// //   //       // Extract the RGB components from the pixel using the image package
// //   //       double r = img.getRed(pixel) / 255.0;   // Normalize red channel
// //   //       double g = img.getGreen(pixel) / 255.0; // Normalize green channel
// //   //       double b = img.getBlue(pixel) / 255.0;  // Normalize blue channel
// //   //
// //   //
// //   //       // Return the normalized RGB values as a list
// //   //       return [r, g, b];  // Shape for each pixel: [r, g, b]
// //   //     });
// //   //   });
// //   //
// //   //   // Add a batch dimension to match the expected input shape [1, 28, 28, 3]
// //   //   List<List<List<List<double>>>> batchTensor = [
// //   //     tensor
// //   //   ];
// //   //
// //   //   // Return the tensor with shape [1, 28, 28, 3]
// //   //   return batchTensor;  // Shape: [1, 28, 28, 3] (batch, height, width, channels)
// //   // }
// //
// //   // void _processPredictions(List<double> output) {
// //   //   List<Map<String, dynamic>> results = [];
// //   //
// //   //   for (int i = 0; i < output.length; i++) {
// //   //     results.add({"label": "Class $i", "confidence": output[i]});
// //   //   }
// //   //
// //   //
// //   //   // Sort by confidence
// //   //   results.sort((a, b) => b["confidence"].compareTo(a["confidence"]));
// //   //
// //   //   setState(() {
// //   //     predictions = results.take(1).toList(); // Top 3 predictions
// //   //   });
// //   //
// //   //   print(results);
// //   //   print(predictions);
// //   //   print(predictions[0]['label'].toString().split(" ")[1]);
// //   //   var predictedLabel = LABELS[int.parse(predictions[0]['label'].toString().split(" ")[1])];
// //   //   // Show the predicted label in a Snackbar
// //   //   ScaffoldMessenger.of(context).showSnackBar(
// //   //     SnackBar(content: Text('Predicted: $predictedLabel')),
// //   //   );
// //   // }
// //
// //   // void _processPredictions(List<double> output) {
// //   //   // Print the output for debugging purposes to check the values
// //   //   print("Model output: $output");
// //   //
// //   //   double threshold = 0.0000001;  // adjust this as needed
// //   //   double maxValue = output.reduce((a, b) => a > b ? a : b);
// //   //
// //   //
// //   //   print(output.reduce(max).toString());
// //   //   print(output.indexOf(output.reduce(max)));
// //   //
// //   //   List<Map<String, dynamic>> top3 = List.generate(output.length, (i) {
// //   //     return {
// //   //       'probability': output[i],
// //   //       'className': LABELS[i],
// //   //       'index': i,
// //   //     };
// //   //   })
// //   //     ..sort((a, b) => b['probability'].compareTo(a['probability']))
// //   //     ..removeRange(3, output.length);
// //   //
// //   //   print(top3);
// //   //
// //   //   // Find the index of the max value if it's above the threshold
// //   //   int maxIndex = -1;
// //   //   for (int i = 0; i < output.length; i++) {
// //   //     if ((output[i] - maxValue).abs() < threshold) {
// //   //       maxIndex = i;
// //   //       break;  // or continue if you want to return the first occurrence of the max
// //   //     }
// //   //   }
// //   //   // Get the label corresponding to the highest confidence
// //   //   String predictedLabel = LABELS[maxIndex];
// //   //
// //   //   // Log the predicted label to the console for debugging
// //   //   print("Predicted label: $predictedLabel");
// //   //
// //   //   // Show the predicted label in a Snackbar
// //   //   ScaffoldMessenger.of(context).showSnackBar(
// //   //     SnackBar(content: Text('Predicted: $predictedLabel')),
// //   //   );
// //   //
// //   //   // Optionally, update the predictions state with the top 3 predictions
// //   //   List<Map<String, dynamic>> results = [];
// //   //   for (int i = 0; i < output.length; i++) {
// //   //     results.add({"label": LABELS[i], "confidence": output[i]});
// //   //   }
// //   //
// //   //   // Sort by confidence in descending order
// //   //   results.sort((a, b) => b["confidence"].compareTo(a["confidence"]));
// //   //
// //   //   setState(() {
// //   //     predictions = results.take(3).toList(); // Top 3 predictions
// //   //   });
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Drawing Activity',
// //           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Text(
// //               'Draw a digit!',
// //               style: GoogleFonts.poppins(
// //                   fontSize: 18, fontWeight: FontWeight.w500),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 20),
// //             AspectRatio(
// //               aspectRatio: 1,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.black, width: 2),
// //                 ),
// //                 child: DrawingBoard(
// //                     controller: _drawingController,
// //                     showDefaultActions: true,
// //                     background: Container(
// //                       width: 400,
// //                       height: 400,
// //                       color: Colors.white,
// //                     )),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _submitDrawing,
// //               style: ElevatedButton.styleFrom(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
// //                 textStyle: GoogleFonts.poppins(fontSize: 16),
// //               ),
// //               child: const Text('Submit'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class Drawingactivity extends StatefulWidget {
//   const Drawingactivity({super.key});

//   @override
//   State<Drawingactivity> createState() => _DrawingactivityState();
// }

// class _DrawingactivityState extends State<Drawingactivity> {
//   WebViewController controller = WebViewController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller.loadRequest(Uri.parse('http://168.138.69.56:8092/'));
//     controller.setJavaScriptMode(JavaScriptMode.unrestricted);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//             appBar: AppBar(
//         title: Text(
//           'Drawing Activity',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(child: WebViewWidget(controller: controller)),
//     );
//   }
// }
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Drawingactivity extends StatefulWidget {
  const Drawingactivity({super.key});

  @override
  _DrawingactivityState createState() => _DrawingactivityState();
}

class _DrawingactivityState extends State<Drawingactivity> {
  List<Offset> points = [];
  late Interpreter interpreter;
  String prediction = '';
  int score = 0;
  String challengeLabel = '';
  List<List<Offset>> strokes = [[]]; // start with one stroke

  final List<String> labels = [
    "The Eiffel Tower",
    "The Great Wall of China",
    "The Mona Lisa",
    "aircraft carrier",
    "airplane",
    "alarm clock",
    "ambulance",
    "angel",
    "animal migration",
    "ant",
    "anvil",
    "apple",
    "arm",
    "asparagus",
    "axe",
    "backpack",
    "banana",
    "bandage",
    "barn",
    "baseball",
    "baseball bat",
    "basket",
    "basketball",
    "bat",
    "bathtub",
    "beach",
    "bear",
    "beard",
    "bed",
    "bee",
    "belt",
    "bench",
    "bicycle",
    "binoculars",
    "bird",
    "birthday cake",
    "blackberry",
    "blueberry",
    "book",
    "boomerang",
    "bottlecap",
    "bowtie",
    "bracelet",
    "brain",
    "bread",
    "bridge",
    "broccoli",
    "broom",
    "bucket",
    "bulldozer",
    "bus",
    "bush",
    "butterfly",
    "cactus",
    "cake",
    "calculator",
    "calendar",
    "camel",
    "camera",
    "camouflage",
    "campfire",
    "candle",
    "cannon",
    "canoe",
    "car",
    "carrot",
    "castle",
    "cat",
    "ceiling fan",
    "cell phone",
    "cello",
    "chair",
    "chandelier",
    "church",
    "circle",
    "clarinet",
    "clock",
    "cloud",
    "coffee cup",
    "compass",
    "computer",
    "cookie",
    "cooler",
    "couch",
    "cow",
    "crab",
    "crayon",
    "crocodile",
    "crown",
    "cruise ship",
    "cup",
    "diamond",
    "dishwasher",
    "diving board",
    "dog",
    "dolphin",
    "donut",
    "door",
    "dragon",
    "dresser",
    "drill",
    "drums",
    "duck",
    "dumbbell",
    "ear",
    "elbow",
    "elephant",
    "envelope",
    "eraser",
    "eye",
    "eyeglasses",
    "face",
    "fan",
    "feather",
    "fence",
    "finger",
    "fire hydrant",
    "fireplace",
    "firetruck",
    "fish",
    "flamingo",
    "flashlight",
    "flip flops",
    "floor lamp",
    "flower",
    "flying saucer",
    "foot",
    "fork",
    "frog",
    "frying pan",
    "garden",
    "garden hose",
    "giraffe",
    "goatee",
    "golf club",
    "grapes",
    "grass",
    "guitar",
    "hamburger",
    "hammer",
    "hand",
    "harp",
    "hat",
    "headphones",
    "hedgehog",
    "helicopter",
    "helmet",
    "hexagon",
    "hockey puck",
    "hockey stick",
    "horse",
    "hospital",
    "hot air balloon",
    "hot dog",
    "hot tub",
    "hourglass",
    "house",
    "house plant",
    "hurricane",
    "ice cream",
    "jacket",
    "jail",
    "kangaroo",
    "key",
    "keyboard",
    "knee",
    "knife",
    "ladder",
    "lantern",
    "laptop",
    "leaf",
    "leg",
    "light bulb",
    "lighter",
    "lighthouse",
    "lightning",
    "line",
    "lion",
    "lipstick",
    "lobster",
    "lollipop",
    "mailbox",
    "map",
    "marker",
    "matches",
    "megaphone",
    "mermaid",
    "microphone",
    "microwave",
    "monkey",
    "moon",
    "mosquito",
    "motorbike",
    "mountain",
    "mouse",
    "moustache",
    "mouth",
    "mug",
    "mushroom",
    "nail",
    "necklace",
    "nose",
    "ocean",
    "octagon",
    "octopus",
    "onion",
    "oven",
    "owl",
    "paint can",
    "paintbrush",
    "palm tree",
    "panda",
    "pants",
    "paper clip",
    "parachute",
    "parrot",
    "passport",
    "peanut",
    "pear",
    "peas",
    "pencil",
    "penguin",
    "piano",
    "pickup truck",
    "picture frame",
    "pig",
    "pillow",
    "pineapple",
    "pizza",
    "pliers",
    "police car",
    "pond",
    "pool",
    "popsicle",
    "postcard",
    "potato",
    "power outlet",
    "purse",
    "rabbit",
    "raccoon",
    "radio",
    "rain",
    "rainbow",
    "rake",
    "remote control",
    "rhinoceros",
    "rifle",
    "river",
    "roller coaster",
    "rollerskates",
    "sailboat",
    "sandwich",
    "saw",
    "saxophone",
    "school bus",
    "scissors",
    "scorpion",
    "screwdriver",
    "sea turtle",
    "see saw",
    "shark",
    "sheep",
    "shoe",
    "shorts",
    "shovel",
    "sink",
    "skateboard",
    "skull",
    "skyscraper",
    "sleeping bag",
    "smiley face",
    "snail",
    "snake",
    "snorkel",
    "snowflake",
    "snowman",
    "soccer ball",
    "sock",
    "speedboat",
    "spider",
    "spoon",
    "spreadsheet",
    "square",
    "squiggle",
    "squirrel",
    "stairs",
    "star",
    "steak",
    "stereo",
    "stethoscope",
    "stitches",
    "stop sign",
    "stove",
    "strawberry",
    "streetlight",
    "string bean",
    "submarine",
    "suitcase",
    "sun",
    "swan",
    "sweater",
    "swing set",
    "sword",
    "syringe",
    "t-shirt",
    "table",
    "teapot",
    "teddy-bear",
    "telephone",
    "television",
    "tennis racquet",
    "tent",
    "tiger",
    "toaster",
    "toe",
    "toilet",
    "tooth",
    "toothbrush",
    "toothpaste",
    "tornado",
    "tractor",
    "traffic light",
    "train",
    "tree",
    "triangle",
    "trombone",
    "truck",
    "trumpet",
    "umbrella",
    "underwear",
    "van",
    "vase",
    "violin",
    "washing machine",
    "watermelon",
    "waterslide",
    "whale",
    "wheel",
    "windmill",
    "wine bottle",
    "wine glass",
    "wristwatch",
    "yoga",
    "zebra",
    "zigzag",
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
    loadScore();
    generateNewChallenge();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
    print("Model loaded");
  }

  Future<void> loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getInt('score') ?? 0;
    });
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('score', score);
  }

  void generateNewChallenge() {
    final random = Random();
    final randomIndex = random.nextInt(labels.length);
    setState(() {
      challengeLabel = labels[randomIndex];
    });
  }

  void clearCanvas() {
    setState(() => strokes = [[]]);
  }

  void onPanUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPos = box.globalToLocal(details.globalPosition);

    setState(() {
      if (strokes.isEmpty) {
        strokes.add([]);
      }
      strokes.last.add(localPos);
    });
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
      strokes.add([]);
      points.add(Offset.infinite);
    });
    print('Stroke ended. Total strokes: ${strokes.length}');
  }

  Future<List<List<List<double>>>> _generateInputTensor() async {
    if (strokes.isEmpty || strokes.every((s) => s.isEmpty)) {
      return List.generate(28, (_) => List.generate(28, (_) => [1.0])); // white
    }

    // Find bounding box
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (var stroke in strokes) {
      for (var p in stroke) {
        minX = minX < p.dx ? minX : p.dx;
        minY = minY < p.dy ? minY : p.dy;
        maxX = maxX > p.dx ? maxX : p.dx;
        maxY = maxY > p.dy ? maxY : p.dy;
      }
    }

    final width = (maxX - minX).ceil();
    final height = (maxY - minY).ceil();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.butt;

    canvas.drawColor(Colors.white, BlendMode.src);

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        final p1 = stroke[i];
        final p2 = stroke[i + 1];
        if (p1 != null && p2 != null) {
          canvas.drawLine(
              p1.translate(-minX, -minY), p2.translate(-minX, -minY), paint);
        }
      }
    }

    final picture = recorder.endRecording();
    final cropped = await picture.toImage(width, height);
    final resized = await _resizeImage(cropped, 28, 28);

    final byteData =
        await resized.toByteData(format: ui.ImageByteFormat.rawRgba);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    List<List<List<double>>> input = List.generate(
        28,
        (y) => List.generate(28, (x) {
              int index = (y * 28 + x) * 4;
              double r = bytes[index].toDouble();
              return [r / 255]; // Use red channel only (grayscale)
            }));

    return input;
  }

  Future<ui.Image> _resizeImage(
      ui.Image image, int targetWidth, int targetHeight) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()));
    final paint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      paint,
    );
    final picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }

  // Future<void> predictDrawing() async {
  //   final input = await _generateInputTensor();
  //   final reshapedInput = input.reshape([1, 28, 28, 1]);
  //   final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

  //   interpreter.run(reshapedInput, output);
  //   final probs = output[0] as List<double>;

  //   print('Probabilities: $probs');

  //   int maxIndex = 0;
  //   double maxProb = probs[0];

  //   for (int i = 1; i < probs.length; i++) {
  //     if (probs[i] > maxProb) {
  //       maxProb = probs[i];
  //       maxIndex = i;
  //     }
  //   }

  //   final predictedLabel = labels[maxIndex];

  //   setState(() {
  //     prediction = '$predictedLabel (${(maxProb * 100).toStringAsFixed(1)}%)';

  //     if (predictedLabel == challengeLabel) {
  //       score++;
  //       saveScore();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('✅ Correct! +1')));
  //       generateNewChallenge();
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('❌ Try again')));
  //     }
  //   });
  // }

  Uint8List? previewImageBytes;

  Future<void> predictDrawing() async {
    try {
      if (strokes.isEmpty || strokes.every((stroke) => stroke.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Draw something first')),
        );
        return;
      }

      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      for (var stroke in strokes) {
        for (var p in stroke) {
          minX = p.dx < minX ? p.dx : minX;
          minY = p.dy < minY ? p.dy : minY;
          maxX = p.dx > maxX ? p.dx : maxX;
          maxY = p.dy > maxY ? p.dy : maxY;
        }
      }

      final width = (maxX - minX).ceil();
      final height = (maxY - minY).ceil();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()
        ..color = ui.Color(0xFF000000)
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      final white = Paint()..color = ui.Color(0xFFFFFFFF);
      canvas.drawRect(
          Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), white);

      for (var stroke in strokes) {
        for (int i = 1; i < stroke.length; i++) {
          final p1 = stroke[i - 1];
          final p2 = stroke[i];
          canvas.drawLine(Offset(p1.dx - minX, p1.dy - minY),
              Offset(p2.dx - minX, p2.dy - minY), paint);
        }
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(width, height);
      final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes == null) throw Exception("Failed to encode PNG");

      final decoded = img.decodeImage(pngBytes.buffer.asUint8List());
      if (decoded == null) throw Exception("Decode failed");

      final resized = img.copyResize(decoded,
          width: 28, height: 28, interpolation: img.Interpolation.average);

      setState(() {
        previewImageBytes = Uint8List.fromList(img.encodePng(resized));
      });

      final input = Float32List(28 * 28);
      for (int y = 0; y < 28; y++) {
        for (int x = 0; x < 28; x++) {
          final pixel = resized.getPixel(x, y);
          final grayscale = img.getLuminance(pixel).toDouble(); // 0–255
          input[y * 28 + x] = grayscale;
        }
      }

      final reshapedInput = input.reshape([1, 28, 28, 1]);

      final output =
          List.filled(labels.length, 0.0).reshape([1, labels.length]);

      interpreter.run(reshapedInput, output);
      final probs = output[0] as List<double>;

      final bestIndex = probs.indexWhere((p) => p == probs.reduce(max));
      final bestLabel = labels[bestIndex];

      setState(() {
        prediction =
            '$bestLabel (${(probs[bestIndex] * 100).toStringAsFixed(1)}%)';
        if (bestLabel == challengeLabel) {
          score++;
          saveScore();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('✅ Correct! +1')));
          generateNewChallenge();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('❌ Try again')));
        }
      });
    } catch (e) {
      print('Prediction error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error during prediction')));
    }
  }

  Future<ui.Image> _renderCanvas() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 280, 280));
    canvas.drawColor(Colors.white, BlendMode.src);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    final picture = recorder.endRecording();
    return await picture.toImage(280, 280);
  }

  Future<List<List<List<double>>>> _preprocessImage(Uint8List bytes) async {
    final decoded = img.decodeImage(bytes)!;
    final resized = img.copyResize(decoded, width: 28, height: 28);

    return List.generate(
      28,
      (y) => List.generate(28, (x) {
        final pixel = resized.getPixel(x, y);
        final grayscale = pixel.r / 255.0;
        return [grayscale];
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎨 Drawing Challenge')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text('Draw: $challengeLabel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('Score: $score',
              style: TextStyle(fontSize: 18, color: Colors.green)),
          const SizedBox(height: 12),
          Container(
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onPanUpdate: onPanUpdate,
              onPanEnd: onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(strokes),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: predictDrawing, child: Text('Predict')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: clearCanvas, child: Text('Clear')),
          const SizedBox(height: 16),
          Text(prediction,
              style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// class DrawingPainter extends CustomPainter {
//   final List<List<Offset>> strokes;
//   DrawingPainter(this.strokes);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 3.0
//       ..strokeCap = StrokeCap.round;

//     for (var stroke in strokes) {
//       for (int i = 0; i < stroke.length - 1; i++) {
//         if (stroke[i] != Offset.infinite && stroke[i + 1] != Offset.infinite) {
//           canvas.drawLine(stroke[i], stroke[i + 1], paint);
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(DrawingPainter oldDelegate) => true;
// }
