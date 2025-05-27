import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:medication/screens/chat_Screen/chat_screen.dart';
import 'package:medication/screens/moodCompanion.dart';
import 'package:medication/screens/rooting_dashboard_screen/rooting_dasshboard_screen.dart';
import 'package:medication/screens/speech_analysis_screen/speech_analysis_page.dart';
import 'package:medication/screens/speech_analysis_screen/start_speech_analysis.dart';
import 'package:medication/screens/welcome_screen/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'routineTracker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  bool canVibrate = false;

  TTSService() {
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US"); // Set language
    await _flutterTts.setPitch(1.0); // Adjust pitch
    await _flutterTts.setSpeechRate(0.5); // Adjust speed
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
    await _flutterTts.clearVoice();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TTSService();
    Provider.of<UserAuthProvider>(context,listen: false).getUserDetails().then((onValue){
      Provider.of<UserAuthProvider>(context,listen: false).createAchatUser();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserAuthProvider>(
          builder: (BuildContext context, authProvider, Widget? child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 35,vertical: 30),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(242, 242, 246, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome ${authProvider.userModel?.name??""}",style: TextStyle(fontSize: 24,fontWeight:FontWeight.w600 ),),
                          Text("MindCare",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600,color: Color.fromRGBO(0, 126, 154, 1), ),),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text("Log Out"),
                              content: Text("Are you sure you want to Log Out?"),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes LogOut'),
                                  onPressed: () {
                                    Provider.of<UserAuthProvider>(context,listen: false).signOut().then((onValue){
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomeScreen(),), (Route<dynamic> route) => false,);
                                    });
                                  },
                                ),
                              ],
                            );
                          },);
                        },
                          child: Icon(Icons.login_rounded,size: 30,color: Colors.redAccent,))
                    ],
                  ),
                  SizedBox(height: 100,),
                  Flexible(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.to(RootingDasshboardScreen());
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(128, 169, 239, 1),
                                      border: Border.all(width: 0.5,color: Colors.white)
                                  ),
                                  width: 96,
                                  height: 93,
                                  child: Image.asset("assets/images/pill 1.png",height: 36,width: 39,),
                                ),
                                SizedBox(height: 10,),
                                Text("Routine Tracker",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              if(canVibrate){
                              }
                              //Get.to(Routinetracker());
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(128, 169, 239, 1),
                                      border: Border.all(width: 0.5,color: Colors.white)
                                  ),
                                  width: 96,
                                  height: 93,
                                  child: Image.asset("assets/images/console 1.png",height: 36,width: 39,),
                                ),
                                SizedBox(height: 10,),
                                Text("Cognitive Monitor",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              if(canVibrate){
                              }
                              Get.to(StartSpeechAnalysis());
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(128, 169, 239, 1),
                                      border: Border.all(width: 0.5,color: Colors.white)
                                  ),
                                  width: 96,
                                  height: 93,
                                  child: Image.asset("assets/images/voice 1.png",height: 36,width: 39,),
                                ),
                                SizedBox(height: 10,),
                                Text("Smart Assistant",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              Get.to(Moodcompanion());
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(128, 169, 239, 1),
                                      border: Border.all(width: 0.5,color: Colors.white)
                                  ),
                                  width: 96,
                                  height: 93,
                                  child: Image.asset("assets/images/yoga 2.png",height: 36,width: 39,),
                                ),
                                SizedBox(height: 10,),
                                Text("Mood Companion",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: 60,
              height: 59,
              decoration: BoxDecoration(
                color: Color.fromRGBO(128, 169, 239, 1),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Icon(Icons.chat_outlined),
            ),
          ),
          Text("Chat",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
        ],
      )
    );
  }
}
