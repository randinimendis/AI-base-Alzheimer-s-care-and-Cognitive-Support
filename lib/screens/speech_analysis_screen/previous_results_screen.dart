import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:intl/intl.dart';
import 'package:medication/provider/speach_recognision_provider.dart';
import 'package:provider/provider.dart';

class PreviousResultsScreen extends StatefulWidget {
  const PreviousResultsScreen({super.key});

  @override
  State<PreviousResultsScreen> createState() => _PreviousResultsScreenState();
}

class _PreviousResultsScreenState extends State<PreviousResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 246, 1),
        title: Text("Reminders",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ),),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Container(
        color: Color.fromRGBO(242, 242, 246, 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<SpeachRecognisionProvider>(builder: (context, speachRecProvider, child) {
            return ListView.builder(itemCount: speachRecProvider.result_List?.length,itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 15,),
                      Flexible(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${DateFormat('MMM dd, yyyy').format(speachRecProvider.result_List!.elementAt(index).dateTime!)}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                SizedBox(height: 6,),
                                Text("Predicated",style: TextStyle(color: Colors.black,fontSize: 15),),
                                SizedBox(height: 6,),
                              ],
                            ),
                            Spacer(),
                            Flexible(
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.pink.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              
                                child: Center(
                                  child: Text(
                                    "${speachRecProvider.result_List!.elementAt(index).result?.toUpperCase()}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(136, 88, 4, 1)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },);
          },
          ),
        ),
      ),
    );
  }
}
