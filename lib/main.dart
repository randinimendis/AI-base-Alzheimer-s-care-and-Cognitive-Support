import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:medication/provider/remind_provider.dart';
import 'package:medication/provider/speach_recognision_provider.dart';
import 'package:medication/screens/wrapper_screen/wrapper_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        // apiKey: "AIzaSyDoZrO3W42wTDckMLt_bJkbIT1hz-uZmac",
        // appId: "1:431207410325:android:223be93cb56dc362c1499c",
        messagingSenderId: "431207410325",
        projectId: "medication-f765c")
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthProvider(),),
        ChangeNotifierProvider(create: (context) => RemindProvider(),),
        ChangeNotifierProvider(create: (context) => SpeachRecognisionProvider(),)
      ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: WrapperScreen(),
    );
  }
}
