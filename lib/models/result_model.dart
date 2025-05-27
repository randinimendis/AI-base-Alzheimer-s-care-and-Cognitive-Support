import 'dart:convert';

class ResultModel{
  DateTime? dateTime;
  String? result;

  ResultModel({required this.dateTime,required this.result});

  factory ResultModel.fromJson(Map<String,dynamic> json){
    return ResultModel(
        dateTime: DateTime.parse(json['dateTime']),
        result: json['result']
    );
  }

  Map<String, dynamic> toJson() => {
    'dateTime': dateTime!.toIso8601String(),
    'title': result,
  };



}