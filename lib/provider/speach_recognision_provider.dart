import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:medication/models/result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeachRecognisionProvider with ChangeNotifier{

  List<ResultModel>? _result_List;
  SharedPreferences? resultPref;

  List<ResultModel>? get result_List => _result_List;

  Future<void> saveResult(DateTime dateTime,String result) async {

    try{
      resultPref = await SharedPreferences.getInstance();

      final String? jsonString = resultPref!.getString("results");
      _result_List = [];
      if(jsonString != null){
        final List<dynamic> decoded = jsonDecode(jsonString);
        _result_List = decoded
            .map((item) => ResultModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      _result_List!.add(
          ResultModel(
              dateTime: dateTime,
              result: result));

      final String updatedJson = jsonEncode(
        _result_List!.map((r) => r.toJson()).toList(),
      );

      await resultPref!.setString("results", updatedJson);

      notifyListeners();
      print("Save result");

    }catch(ex){
      print(ex);
    }
  }

  Future<void> fetchResult()async{
    resultPref = await SharedPreferences.getInstance();

    final String? jsonString = resultPref!.getString("results");
    _result_List = [];

    if(jsonString != null){
      final List<dynamic> decoded = jsonDecode(jsonString);
      _result_List = decoded
          .map((item) => ResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }
}