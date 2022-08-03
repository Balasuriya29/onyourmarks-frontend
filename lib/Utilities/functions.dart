import 'package:flutter/material.dart';
import 'package:onyourmarks/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/navigator.dart';
import 'dart:convert';

import '../Pages/Students/StudentHome.dart';
import '../Pages/Teachers/TeacherHome.dart';
import '../../Models/Student Models/UserModel.dart';
import '../../staticNames.dart';

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.get("token").toString();
}

Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString("token").toString();

  var req = await http.get(
      Uri.parse(API_LINK+"api/admin/role"),
      headers: {
        "x-auth-token" : token
      }
  );
  return req.body.toString();
}

void goToRespectiveHomeScreen(BuildContext context) async{
  var role = await getRole();
  if(role == "Student")
    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome()));

  if(role == "Teacher")
    Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherHome()));
}

Future<UserModel> checkMe(String username, String password) async{
  var body = jsonEncode({
    "username" : username,
    "password" : password
  });
  var req = await http.post(
      Uri.parse("${API_LINK}api/user/check"),
      headers:{
        "content-type":"application/json"
      },
      body: body
  );

  var res = jsonDecode(req.body);
  var um = UserModel(res["username"],res["user_id"],res["isAdmin"],res["isRegistered"]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("token", req.headers['x-auth-token'].toString());

  return um;
}

Future<bool> changePassword(String username, String newPassword) async{
  var body = jsonEncode({
    "newPassword" : newPassword
  });

  var req = await http.put(
      Uri.parse("${API_LINK}api/user/password/${username}"),
      headers:{
        "content-type":"application/json"
      },
      body: body
  );

  var res = jsonDecode(req.body);

  return res["isRegistered"];
}