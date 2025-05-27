import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medication/screens/speech_analysis_screen/speech_analysis_page.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(242, 242, 246, 1),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Instructions",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 34,),textAlign: TextAlign.center,),
              SizedBox(height: 40,),
              Text("Please answer questions - clearly using verce.",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,),textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Text("The system will analyze your speech to detect Alzheimers as stage.",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,),textAlign: TextAlign.center,),
              SizedBox(height: 100,),
              GestureDetector(
                onTap: (){
                  Get.to(SpeechAnalysisPage());
                },
                  child: createButton(isShowboarder: true, buttonText: "Continue to Questions")),
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
