import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_popup/smart_popup.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ScanService extends GetxController{

  @override
  void onInit(){
    super.onInit();
  }

  @override
  void dispoce(){
    super.dispose();
    Tflite.close();
    cameraController.dispose();
  }


  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  var detectedObject = "".obs;
  String lastSpokenObject = '';


  void updateDetectedObject(String newObject) {
    if (newObject != lastSpokenObject) {
      detectedObject.value = newObject;
      lastSpokenObject = newObject;
    }
  }


  initCamera(BuildContext context) async{
    if(await Permission.camera.request().isGranted){
      cameras = await availableCameras();
      
      cameraController = await CameraController(
          cameras[0],
          ResolutionPreset.max);
      await cameraController.initialize().then((onValue){
          cameraController.startImageStream((image){
            cameraCount ++;
            if(cameraCount %10 == 0){
              cameraCount = 0;
              objectDetector(image,context);
            }

          });
      });
      isCameraInitialized(true);
      update();
    }
    else{
      print("Permission denied");
    }
  }

  stopCamera()async{
    if(isCameraInitialized.value){
      cameraController.stopImageStream();
      isCameraInitialized(false);
      update();
      await cameraController.dispose();
    }
  }

  initTFLite() async{
    try{
      await Tflite.loadModel(
          model: "assets/medicine/model.tflite",
          labels: "assets/medicine/labels.txt",
          isAsset:true,
          numThreads: 1,
          useGpuDelegate: false
      );
    }catch(ex){
      print(ex);
    }

  }

  Uint8List convertYUV420ToUint8List(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final yBuffer = image.planes[0].bytes;
    final uBuffer = image.planes[1].bytes;
    final vBuffer = image.planes[2].bytes;

    final Uint8List bytes = Uint8List(yBuffer.length + uBuffer.length + vBuffer.length);
    int index = 0;
    bytes.setRange(index, index + yBuffer.length, yBuffer);
    index += yBuffer.length;
    bytes.setRange(index, index + uBuffer.length, uBuffer);
    index += uBuffer.length;
    bytes.setRange(index, index + vBuffer.length, vBuffer);

    return bytes;
  }

  Future<File> saveImage(Uint8List bytes) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  }
  
  objectDetector(CameraImage image,BuildContext context) async{
    try{
      var detector = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((e){
            return e.bytes;
          }).toList(),
          asynch: true,
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 1,
          rotation: 90,
          threshold: 0.4
      );

      if(detector != null){
        if(detector[0]['confidence']>=0.82 && detector[0]['confidence']<0.9999064207077026){
          String label = detector[0]['label'];
          detectedObject.value = label.replaceAll(RegExp(r'[0-9\s]'), '');
          update();
          print("Result is $label");
          stopCamera();
          File? imageFile;
          await saveImage(convertYUV420ToUint8List(image)).then((onValue){
            imageFile = onValue;
          });
          showDialog(
            context: context,
            builder: (context) => SmartPopup(
              title: "${detectedObject.value}",
              primaryButtonText: "More Details",
              showCloseButton: false,
              primaryButtonColor: Color.fromRGBO(0, 126, 154, 1),
              primaryButtonTextColor: Colors.white,
              primaryButtonTap: () {
                Navigator.of(context).pop();
              },
              // Do not pass image and video simultaneously; pass one at a time.
              //imagePath: imageFile!.path,
              // videoPath: "assets/videos/your_video.mp4",
              // videoVolume: 100,
              // videoPlayBackSpeed: 2.5,
              // timerDelay: 10,
              // animationType: AnimationType.scale,
            )
          );
        }
        else{
          detectedObject.value = "";
          update();
          print("Detecting objects...");
        }
      }
    }catch(ex){
      print("Exception ${ex}");
    }
  }

}