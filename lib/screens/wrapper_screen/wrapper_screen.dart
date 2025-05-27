import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:medication/screens/main_screen.dart';
import 'package:medication/screens/welcome_screen/welcome_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}


class _WrapperScreenState extends State<WrapperScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogedIn();
    permissionCheck();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/splash_screen.png"),fit: BoxFit.cover)
        ),
      ),
    );
  }

  Future<void> checkLogedIn() async {
    final bool isLogedIn = await Provider.of<UserAuthProvider>(context,listen: false).isLogedIn();
    if(isLogedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen(),));
    }
  }

  Future<void> permissionCheck() async {

    if(await Permission.notification.request().isGranted){
      print("Notification permission granted");
    }
  }
}
