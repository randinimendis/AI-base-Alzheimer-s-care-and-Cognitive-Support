import 'dart:convert';

class ReminderModel{
  int? id;
  DateTime? dateTime;
  String? title;

  ReminderModel({required this.id,required this.dateTime,required this.title});

  factory ReminderModel.fromJson(Map<String,dynamic> json){
    return ReminderModel(
        id: json['id'],
        dateTime: DateTime.parse(json['dateTime']),
        title: json['title']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateTime': dateTime!.toIso8601String(),
    'title': title,
  };



}