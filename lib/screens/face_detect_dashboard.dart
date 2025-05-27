import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:medication/screens/excersice_screen.dart';
import 'package:medication/screens/music_screen.dart';
import 'package:medication/screens/yoga_meditaion_screen.dart';
import 'package:provider/provider.dart';

class FaceDetectDashboard extends StatefulWidget {
  final String faceType;
  const FaceDetectDashboard({super.key,required this.faceType});

  @override
  State<FaceDetectDashboard> createState() => _FaceDetectDashboardState();
}

class _FaceDetectDashboardState extends State<FaceDetectDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 246, 1),
        title: Consumer<UserAuthProvider>(builder: (BuildContext context, userAuthProvider, Widget? child) {
          return Text("Good Morning ${userAuthProvider.userModel?.name??""} ${widget.faceType=="Happy"?"😄":widget.faceType=="Sad"?"😟":"😡"}",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ),);
        }),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35,vertical: 30),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 242, 246, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: (){
                                Get.to(MusicScreen(faceType: widget.faceType));
                              },
                              child: Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                  )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(child: Image.asset("assets/images/img1.png",)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Music",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          Flexible(
                            child: GestureDetector(
                              onTap: (){
                                Get.to(ExcersiceScreen(faceType: widget.faceType));
                              },
                              child: Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(child: Image.asset("assets/images/img2.png",)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Exercises",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),

                      SizedBox(height: 10,),

                      GestureDetector(
                        onTap: (){
                          Get.to(YogaMeditaionScreen(faceType: widget.faceType));
                        },
                        child: Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: Image.asset("assets/images/img3.png",)),
                              SizedBox(height: 10,),
                              Flexible(child: Text("Yoga And Meditation",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
