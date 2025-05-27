import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:medication/models/reminder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindProvider with ChangeNotifier{
  List<ReminderModel>? _reminder_List;
  SharedPreferences? remindPref;

  List<ReminderModel>? get reminder_List => _reminder_List;

  Future<void> saveReminder(int reminderId,DateTime dateTime,String title) async {

    try{
      remindPref = await SharedPreferences.getInstance();

      final String? jsonString = remindPref!.getString("reminders");
      _reminder_List = [];
      if(jsonString != null){
        final List<dynamic> decoded = jsonDecode(jsonString);
        _reminder_List = decoded
            .map((item) => ReminderModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      _reminder_List!.add(
          ReminderModel(
              id: reminderId,
              dateTime: dateTime,
              title: title));

      final String updatedJson = jsonEncode(
        _reminder_List!.map((r) => r.toJson()).toList(),
      );

      await remindPref!.setString("reminders", updatedJson);

      notifyListeners();

      final alarmSettings = AlarmSettings(
        iOSBackgroundAudio: true,
        androidStopAlarmOnTermination: true,
        id: reminderId,
        dateTime: dateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: false,
        vibrate: true,
        warningNotificationOnKill: Platform.isIOS,
        androidFullScreenIntent: false,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: title,
          body: '$title Reminder',
          stopButton: 'Stop the alarm',
          icon: 'notification_icon',
          iconColor: Color.fromRGBO(64, 124, 226, 1),
        ),
      );

      await Alarm.set(alarmSettings: alarmSettings);
      print("Alarm Saved");
    }catch(ex){
      print(ex);
    }
  }

  Future<void> fetchReminder()async{
    remindPref = await SharedPreferences.getInstance();

    final String? jsonString = remindPref!.getString("reminders");
    _reminder_List = [];

    if(jsonString != null){
      final List<dynamic> decoded = jsonDecode(jsonString);
      _reminder_List = decoded
          .map((item) => ReminderModel.fromJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }
  

}