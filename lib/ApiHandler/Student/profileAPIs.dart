import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/functions.dart';
import '../../Models/Student Models/SubjectModel.dart';
import '../../Models/Student Models/TeacherModel.dart';
import '../../Utilities/staticNames.dart';

getStudentMe() async {
  var token = await getToken();
  var res = await http.get(
      Uri.parse("${API_LINK}api/admin/me"),
      headers: {
        "x-auth-token": token,
      }
  );
  // print(res.body);
  var me = json.decode(res.body);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("student-id", me["_id"].toString());
  preferences.setString("student-personalDetails", res.body);
}

Future<List<TeacherModel>> getMyTeachers(String stdId) async{
  var token = await getToken();
  List<TeacherModel> teachers = [];
  var req = await http.get(
      Uri.parse("${API_LINK}api/student/myteachers/$stdId"),
      headers: {
        "x-auth-token" : token
      }
  );
  var res = jsonDecode(req.body);
  for(var i in res){
    SubjectModel sm = SubjectModel.forTeachers(i["subject_id"]["_id"], i["subject_id"]["sub_name"], i["subject_id"]["total_marks"].toString());
    TeacherModel tm = TeacherModel.forMyTeachers(i["teacher_id"]["_id"], i["teacher_id"]["name"], sm);
    teachers.add(tm);
  }
  return teachers;
}