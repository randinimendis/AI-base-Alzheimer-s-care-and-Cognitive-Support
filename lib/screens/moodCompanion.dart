import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication/services/face_scan_service.dart';

class Moodcompanion extends StatefulWidget {
  const Moodcompanion({super.key});

  @override
  State<Moodcompanion> createState() => _MoodcompanionState();
}

class _MoodcompanionState extends State<Moodcompanion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: FaceScanService(),
        builder: (controller) {
          return Stack(
            children: [
              controller.isCameraInitialized.value?
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(controller.cameraController)
                ),
              )
                  :
              SizedBox(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/face-detection.gif",color: Colors.blue,),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
