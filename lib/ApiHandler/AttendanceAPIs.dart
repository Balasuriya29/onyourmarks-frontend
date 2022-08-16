import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onyourmarks/Models/Teacher%20Models/StudentModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Utilities/functions.dart';
import '../Utilities/staticNames.dart';

Future<bool> addAttendance(String id, String date) async{
  bool posted = false;
  var token = await getToken();

  var body = json.encode({
    "Dates" : date.toString()
  });
  // print(body);
  await http.post(
      Uri.parse("${API_LINK}api/teacher/add-student-attendance/"+id),
      headers: {
        "x-auth-token":token,
        "content-type":"application/json"
      },
      body: body
  )
      .then((value){
        var res = value.body.toString();
    debugPrint("Posted Attendance : $res");
    posted = true;
  })
      .catchError((err) {
    debugPrint("UnExpected Error$err");
  });
  return posted;
}

Future<bool> removeAttendance(String id, String date) async{
  bool removed = false;
  var token = await getToken();

  var body = json.encode({
    "Dates" : date.toString()
  });
  // print(body);
  await http.post(
      Uri.parse("${API_LINK}api/teacher/remove-student-attendance/"+id),
      headers: {
        "x-auth-token":token,
        "content-type":"application/json"
      },
      body: body
  )
      .then((value){
    var res = value.body.toString();
    debugPrint("Removed Attendance : $res");
    removed = true;
  })
      .catchError((err) {
    debugPrint("UnExpected Error$err");
  });
  return removed;
}

Future<List<StudentModel>?> getAttendance(String id, DateTime date) async {
  List<StudentModel> list = [];
  var token = await getToken();
  await http.get(
    Uri.parse("${API_LINK}api/teacher/student-attendance/"+id),
    headers: {
    "x-auth-token":token,
    },
  ).then((value){
    var res = jsonDecode(value.body);
    // var index = 0;
    for(var i in res){
      var name = i["student_id"]["first_name"]+i["student_id"]["last_name"];
      var id = i["student_id"]["_id"];
      var dates = i["Dates"];
      var stdName = i["std_id"]["std_name"];
      var posted = false;
      var now = DateTime(date.year,date.month,date.day).toString().substring(0,10);
      if(dates.contains(now)){
        posted = true;
      }
      list.add(StudentModel.forAttendance(name, id, stdName, posted));
    }
  })
      .catchError((err) {
    debugPrint("UnExpected Error$err");
  });
  return list;
}

Future<List<dynamic>> getMyAttendance() async {
  var list;
  var token = await getToken();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var id = preferences.getString("student-id");
  await http.get(
    Uri.parse("${API_LINK}api/student/my-attendance/"+id!),
    headers: {
      "x-auth-token":token,
    },
  ).then((value){
    var res = jsonDecode(value.body);
    list = res[0]["Dates"];
  })
      .catchError((err) {
    debugPrint("UnExpected Error$err");
  });
  return list;
}