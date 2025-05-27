import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:medication/provider/remind_provider.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
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
          child: Consumer<RemindProvider>(builder: (context, remindProvider, child) {
            return ListView.builder(itemCount: remindProvider.reminder_List?.length,itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: RandomColor.getColorObject(Options(
                            colorType: ColorType.blue,
                            luminosity: Luminosity.dark,
                          )
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(Icons.notifications,color: Colors.white,),
                      ),
                      SizedBox(width: 15,),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${remindProvider.reminder_List!.elementAt(index).title}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            SizedBox(height: 10,),
                            Text("${remindProvider.reminder_List!.elementAt(index).dateTime}",style: TextStyle(color: Color.fromRGBO(64, 124, 226, 1)),),
                            SizedBox(height: 6,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1.5,
                              color: Colors.grey.shade600,
                            )
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
