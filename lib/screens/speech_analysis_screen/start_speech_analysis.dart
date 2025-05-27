import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medication/provider/speach_recognision_provider.dart';
import 'package:medication/screens/speech_analysis_screen/Instruction_screen.dart';
import 'package:medication/screens/speech_analysis_screen/previous_results_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/remind_provider.dart';

class StartSpeechAnalysis extends StatefulWidget {
  const StartSpeechAnalysis({super.key});

  @override
  State<StartSpeechAnalysis> createState() => _StartSpeechAnalysisState();
}

class _StartSpeechAnalysisState extends State<StartSpeechAnalysis> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SpeachRecognisionProvider>(context,listen: false).fetchResult();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(242, 242, 246, 1),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              Text("Cognitive Speech Checker",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 34,),textAlign: TextAlign.center,),
              SizedBox(height: 100,),
              GestureDetector(onTap: (){
                Get.to(InstructionScreen());
              },child: createButton(isShowboarder: true, buttonText: "Start New Assessment")),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Get.to(PreviousResultsScreen());
                },
                  child: createButton(isShowboarder: true, buttonText: "View Previous Results")),
            ],
          ),
        ),
      ),
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
