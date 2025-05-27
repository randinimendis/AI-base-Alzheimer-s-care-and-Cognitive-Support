import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../services/scan_service.dart';

class Routinetracker extends StatefulWidget {

  @override
  State<Routinetracker> createState() => _CurrencyDetectorScreen();
}

class _CurrencyDetectorScreen extends State<Routinetracker> {
 final ScanService scanService = Get.put(ScanService());
 final FlutterTts _flutterTts = FlutterTts();


  TTSService() {
    _initializeTTS();
  }

 @override
 void dispoce(){
   super.dispose();

 }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US"); // Set language
    await _flutterTts.setPitch(2.0); // Adjust pitch
    await _flutterTts.setSpeechRate(0.5); // Adjust speed
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),

      body:GetBuilder<ScanService>(
        init: ScanService(),
        builder: (controller) {
          return Stack(
            children: [
              controller.isCameraInitialized.value?
              Container(
                  padding:EdgeInsets.symmetric(horizontal: 10),
                  height: 504,
                  child: CameraPreview(controller.cameraController)
              )
                  :
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 504,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 126, 154, 0.5)
                  ),
                    ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.isCameraInitialized.value?"SCANNING...":"",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    controller.isCameraInitialized.value?Container(
                        width: 300,
                        decoration:BoxDecoration(
                      border: Border.all(width: 2,color: Colors.grey.withOpacity(0.6)),
                          borderRadius: BorderRadius.circular(15)
                    ),
                    child: Image.asset("assets/images/scanner.gif",)):SizedBox(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: SizedBox(
                    width: 237,
                    height: 45,
                    child: ElevatedButton(onPressed: (){
                      print(scanService.isCameraInitialized);
                      if(scanService.isCameraInitialized()!= true){
                        scanService.initCamera(context);
                        scanService.initTFLite();
                      }else{
                        scanService.stopCamera();
                      }
                    },
                        child: Text(!controller.isCameraInitialized()?"Scan Medication":"Stop Medication"),
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(0, 126, 154, 1),
                        foregroundColor: Colors.white
                      )
                    ),
                  ),
                ),
              )
            ],
          );
        }
      )
    );
  }
}
