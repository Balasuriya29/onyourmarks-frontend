import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'dart:convert';

import '../Pages/Students/StudentHome.dart';
import '../Pages/Teachers/TeacherHome.dart';
import '../../Models/Student Models/UserModel.dart';
import 'staticNames.dart';

List<String> texts = [APP_NAME, "Username", "Password", "Login", 'Home'];

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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHome(0)));

  if(role == "Teacher")
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherHome(0)));
}

Future<UserModel> checkMe(String username, String password) async{
  var um = UserModel.empty("Error",true);
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

  if(req.body.toString() == "Invalid UserName" || req.body.toString() == "Invalid Password"){
    toast(req.body.toString());
    return um;
  }

  var res = jsonDecode(req.body);
  um = UserModel(res["username"],res["user_id"],res["isAdmin"],res["isRegistered"]);

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

void toast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

void popPagesNtimes(BuildContext context, int times) {
  var count = 0;
  Navigator.popUntil(context, (route) {
    return count++ == times;
  });
}

Future<void> changeLanguage(String lang) async {
  GoogleTranslator translator = GoogleTranslator();
  var index = 0;
  for(var i in texts){
    var newText = "";
    (lang == "Marathi")
        ?await translator.translate(APP_NAME, from: 'en', to: 'mr').then((v){
          newText = v.text;
        })
        :await translator.translate(APP_NAME, from: 'mr', to: 'en').then((v){
      newText = v.text;
    });
    texts[index++] = newText;
  }
  // print(texts.toString());
}