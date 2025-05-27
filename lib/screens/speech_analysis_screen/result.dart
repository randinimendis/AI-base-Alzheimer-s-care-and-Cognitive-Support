import 'dart:math';
import 'package:flutter/material.dart';
import 'package:medication/provider/speach_recognision_provider.dart';
import 'package:provider/provider.dart';
import 'speech_analysis_page.dart';

class ResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> serverResponses;

  const ResultPage({Key? key, required this.serverResponses}) : super(key: key);

  // Helper function to compute the final category.
  String computeFinalCategory(List<Map<String, dynamic>> responses) {
    int severeCount = 0;
    int earlyCount = 0;
    int moderateCount = 0;

    for (var response in responses) {
      String predictedLabel = response['predictedLabel'] ?? "";
      String category;
      if (predictedLabel == "Patient's Confused Respond" || predictedLabel == "Patient's Minimum respond") {
        category = "severe";
      } else if (predictedLabel == "Patient's Delay Respond") {
        category = "moderate";
      } else if (predictedLabel == "Patient's Fluent Respond" ||
          predictedLabel == "Patient's Repeat respond") {
        category = "early";
      } else {
        category = "early"; // Fallback to early if unknown.
      }

      if (category == "severe") {
        severeCount++;
      } else if (category == "early") {
        earlyCount++;
      } else if (category == "moderate") {
        moderateCount++;
      }
    }

    // If all 3 are early, randomly show "early" or "moderate".
    if (earlyCount == 3) {
      List<String> options = ["early", "moderate"];
      return options[Random().nextInt(options.length)];
    }

    // If at least 2 responses are severe, final category is severe.
    if (severeCount >= 2) {
      return "severe";
    }
    // Otherwise, if there are at least 2 responses that are early or moderate,
    // randomly choose one of the available options.
    else if ((earlyCount + moderateCount) >= 2) {
      List<String> options = [];
      if (earlyCount > 0) options.add("early");
      if (moderateCount > 0) options.add("moderate");
      return options[Random().nextInt(options.length)];
    }
    // Default to early.
    return "early";
  }

  @override
  Widget build(BuildContext context) {
    // Compute the final overall category from server responses.
    String finalCategory = computeFinalCategory(serverResponses);

    // Fixed values for our custom bar graph.
    final List<double> testValues = [3.5, 4.2, 2.8];
    final double maxValue = 5.0; // Maximum value for scaling.
    final double graphHeight = 200; // Height available for the graph.

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assessment Result",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(242, 242, 246, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gray box at the top showing the final overall category.
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15)
              ),

              child: Center(
                child: Text(
                  "${finalCategory.toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(136, 88, 4, 1)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Custom bar graph built with standard widgets.
            Text("Speech Analysis Summary",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,),textAlign: TextAlign.left,),
            SizedBox(height: 20,),
            Text("Filler Words Detected: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,),textAlign: TextAlign.left,),
            SizedBox(height: 20,),
            Text("Repeated Words Unth: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,),textAlign: TextAlign.left,),
            // SizedBox(
            //   height: graphHeight,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       _buildBar("Fluency", testValues[0], maxValue, graphHeight, Colors.blue),
            //       _buildBar("Verbal", testValues[1], maxValue, graphHeight, Colors.green),
            //       _buildBar("Story", testValues[2], maxValue, graphHeight, Colors.orange),
            //     ],
            //   ),
            // ),


            Spacer(),

            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("💡 Hint:",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  Text("Try's speak slowly and describe daily activities. This may improve fluency and clarity.",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16))
                ],
              ),
            ),

            const SizedBox(height: 25),
            Row(
                children: [
                  Flexible(child:
                  GestureDetector(onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },child: createButton(isShowboarder: true, buttonText: "Try Again"))),
                  SizedBox(width: 5,),
                  Flexible(child: GestureDetector(
                    onTap: (){
                      Provider.of<SpeachRecognisionProvider>(context,listen: false).saveResult(DateTime.now(), finalCategory);
                    },
                      child: createButton(isShowboarder: true, buttonText: "Save Report")))
            ]),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigate to a fresh SpeechAnalysisPage by removing all previous routes.
            //       Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const SpeechAnalysisPage(),
            //         ),
            //             (route) => false,
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       textStyle: const TextStyle(fontSize: 18),
            //     ),
            //     child: const Text("Analyze Again"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each bar in the graph.
  Widget _buildBar(
      String label,
      double value,
      double maxValue,
      double graphHeight,
      Color color,
      ) {
    // Calculate the bar height based on the value and the maximum value.
    double barHeight = (value / maxValue) * graphHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: barHeight,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText, bool? isLoading}){
    return Container(
      width: 300,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
          border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child:(isLoading??false)?CircularProgressIndicator(color: Colors.white,):Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }
}
