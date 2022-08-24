import 'dart:convert';

import 'package:onyourmarks/Models/HomeWorkModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/functions.dart';
import '../Utilities/staticNames.dart';

Future<List<HomeWorkModel>> getMyHomeWorks(String std_id) async{
  var token = await getToken();

  List<HomeWorkModel> hws = [];

  var req = await http.get(
      Uri.parse("${API_LINK}api/student/my-homeworks/"+std_id),
      headers: {
        "x-auth-token":token,
      }
  );

  var response = jsonDecode(req.body);

  for(var i in response){
    HomeWorkModel hw = HomeWorkModel.forStudents(
      i["title"],
      i["description"],
      i["teacher_id"]["name"],
      i["date"],
      i["subject"]
    );
    hws.add(hw);
  }

  return hws;
}

Future<List<HomeWorkModel>> getAllHomeWorks() async{
  var token = await getToken();

  List<HomeWorkModel> hws = [];

  var req = await http.get(
      Uri.parse("${API_LINK}api/teacher/all-homeworks"),
      headers: {
        "x-auth-token":token,
      }
  );

  var response = jsonDecode(req.body);

  for(var i in response){
    HomeWorkModel hw = HomeWorkModel.forTeachers(
        i["title"],
        i["description"],
        i["teacher_id"]["name"],
        i["date"],
        i["subject"],
        i["std_id"]["std_name"]
    );
    hws.add(hw);
  }

  return hws;
}

postHomeWork(String subject, String title, String desc, String std_id, DateTime date) async{
  var token = await getToken();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  var body = jsonEncode({
    "title" : title,
    "description" : desc,
    "subject" : subject,
    "teacher_id" : preferences.getString("teacher-id"),
    "std_id" : std_id,
    "date" : date.toString()
  });

  var req = await http.post(
      Uri.parse("${API_LINK}api/teacher/homework"),
      headers: {
        "x-auth-token":token,
        "content-type":"application/json"
      },
      body : body
  );
}