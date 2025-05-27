import 'package:flutter/material.dart';
import 'package:medication/screens/auth_screen/signIn_screen.dart';

import '../auth_screen/signUp_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            Text("MediCare",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Color.fromRGBO(34, 58, 106, 1)),),
            SizedBox(height: 10,),
            Text("Let's get started!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            Text("Login to Stay healthy and fit",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.grey.shade500),),
            SizedBox(height: 40,),
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen(),));
                },
                child: createButton(isShowboarder: true,buttonText: "Login")),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
              },
                child: createButton(isShowboarder: false, buttonText: "Sign Up"))
          ],
        ),
      ),
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText}){
    return Container(
      width: 250,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
        border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child: Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }
}
