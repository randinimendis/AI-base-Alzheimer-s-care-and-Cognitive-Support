import 'dart:io';
import 'dart:math';

import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:medication/provider/remind_provider.dart';
import 'package:medication/screens/rooting_dashboard_screen/reminder_screen.dart';
import 'package:medication/screens/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../routineTracker.dart';

class RootingDasshboardScreen extends StatefulWidget {
  const RootingDasshboardScreen({super.key});

  @override
  State<RootingDasshboardScreen> createState() => _RootingDasshboardScreenState();
}

class _RootingDasshboardScreenState extends State<RootingDasshboardScreen> {

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<RemindProvider>(context,listen: false).fetchReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 246, 1),
        title: Text("Rooting Dashboard",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ),),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Consumer<RemindProvider>(
        builder: (BuildContext context, remindProvider, Widget? child) {
          return Container(
            color: Color.fromRGBO(242, 242, 246, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            Get.to(Routinetracker());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(64, 124, 226, 1),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
                                ),
                                SizedBox(height: 5,),
                                Text("Scan",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:Colors.grey.shade500),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            showDialog(context: context, barrierDismissible: false ,builder: (context) {
                              return AlertDialog(
                                title: Text("Set Reminder"),
                                content: Container(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      CustomText(textController: titleController, hintText: "Title", prefixIcon: Icons.title),
                                      SizedBox(height: 15,),
                                      GestureDetector(
                                          onTap: () async {
                                            final date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100),initialDate: DateTime.now());
                                            if(date != null){
                                              dateController.text = DateFormat('yyyy-MM-dd').format(date);;
                                            }
                                          },
                                          child: CustomText(textController: dateController, hintText: "Select a Date", prefixIcon: Icons.calendar_month_outlined,isEnable: false,)),
                                      SizedBox(height: 15,),
                                      GestureDetector(
                                          onTap: () async {
                                            final time = await showTimePicker(context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
                                            final hour = time?.hour.toString().padLeft(2, '0');
                                            final minute = time?.minute.toString().padLeft(2, '0');
                                            if(time != null){
                                              timeController.text = "$hour:$minute";
                                            }
                                          },
                                          child: CustomText(textController: timeController, hintText: "Select a Time", prefixIcon: Icons.timer,isEnable: false,))
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      titleController.text = "";
                                      timeController.text = "";
                                      dateController.text = "";

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Save'),
                                    onPressed: () {
                                      final reminderDateTime = DateTime.parse("${dateController.text}T${timeController.text}:00");
                                      final title = titleController.text.trim();
                                      final reminderId = Random().nextInt(1000);

                                      Provider.of<RemindProvider>(context,listen: false).saveReminder(reminderId, reminderDateTime, title).then((onValue){
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },);
                            // showDatePicker(
                            //     context: context,
                            //     firstDate: DateTime(2000),
                            //     lastDate: DateTime(2100)
                            // );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(64, 124, 226, 1),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Icon(Icons.calendar_month_outlined,color: Colors.white,),
                                ),
                                SizedBox(height: 5,),
                                Text("Scheduled",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:Colors.grey.shade500),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Text("My Lists",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  SizedBox(height: 25,),
                  GestureDetector(
                    onTap: (){
                      Get.to(ReminderScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      height: 110,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Icon(Icons.calendar_month_outlined,color: Colors.white,),
                          ),
                          SizedBox(width: 10,),
                          Text("Reminders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:Colors.black),),
                          Spacer(),
                          Text("${remindProvider.reminder_List?.length??0}"),
                          SizedBox(width: 5,),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey.shade500,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
