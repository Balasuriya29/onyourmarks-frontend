import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Student Models/ExamModel.dart';
import '../../Models/Student Models/MarksModel.dart';
import '../../Models/Student Models/SubjectModel.dart';
import '../../Utilities/staticNames.dart';
// Future<List<TeacherModel>> getMyTeachers(String stdId) async{
//   var token = await getToken();
//   List<TeacherModel> teachers = [];
//   var res = await http.get(Uri.parse(API_LINK+"api/student/myteachers/"+stdId),
//     headers: {
//         "x-auth-token" : token,
//         "content-type" : "application/json"
//     }
//   );
//   var teacher = json.decode(res.body);
//   for(var i in teacher){
//       TeacherModel teacher = TeacherModel.forStudents(i['teacher_id']['_id'], i['teacher_id']['name'], i['subject_id']['sub_name']);
//       teachers.add(teacher);
//   }
//   return teachers;
// }

getMyExams() async{
  var token = await getToken();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var stdId = jsonDecode(preferences.getString("student-personalDetails").toString());
  List<ExamModel> exams = [];
  var res = await http.get(Uri.parse(API_LINK+"api/student/myexams/"+stdId["std_id"]["_id"]),
      headers: {
        "x-auth-token" : token,
        "content-type" : "application/json"
      }
  );
  // debugPrint(res.body);
  var exam = json.decode(res.body);
  // print("after exam");
  for(var i in exam) {
    // print("i"+i.toString());
    if (!(i.toString() == "[]")) {
      int index = 0;
      List<SubjectModel> subjects = [];
      for (var k in i["exam_id"]["subjects"]) {
        SubjectModel sm = SubjectModel(
            k["_id"],
            k["sub_name"],
            k["total_marks"].toString(),
            i["exam_id"]["dates"][index++].toString()
        );
        subjects.add(sm);
      }
      ExamModel em = ExamModel(
          i["exam_id"]["_id"].toString(),
          i["exam_id"]["exam_name"].toString(),
          subjects,
          i["exam_id"]["status"]
      );
      exams.add(em);
      // print(exams);
    }
  }
  return exams;
}

Future<Map<String, List<MarksModel>>> getMyMarks() async{
  var token = await getToken();
  Map<String,List<MarksModel>> map ={} ;
  var res = await http.get(Uri.parse(API_LINK+"api/student/mymarks"),
      headers: {
        "x-auth-token" : token,
        "content-type" : "application/json"
      }
  );
  // debugPrint(res.body);
  var marks = json.decode(res.body);
  var index = 0;
  for(var i in marks){
    if(map.containsKey(i["exam_id"]["exam_name"])){
      map[i["exam_id"]["exam_name"]]?.add(new MarksModel(i["exam_id"]["_id"], i["exam_id"]["exam_name"], i["subject_id"]["sub_name"], i["subject_id"]["total_marks"].toString(), i["obtained"].toString(), i["exam_id"]["dates"][index]));
    }
    else{
      map.addAll({
        i["exam_id"]["exam_name"]:[new MarksModel(i["exam_id"]["_id"], i["exam_id"]["exam_name"], i["subject_id"]["sub_name"], i["subject_id"]["total_marks"].toString(), i["obtained"].toString(), i["exam_id"]["dates"][index])]
      });
    }
    index++;
  }
  // debugPrint("After models");
  return map;
}

Future<bool> postInterests(List<String> interests, List<int> counts, String reqType) async{
  var token = await getToken();
  var check = true;
  var body = (reqType == 'post')
      ?jsonEncode({
         "interests" : interests,
         "counts":counts
      })
      :jsonEncode({
         "counts":counts
      });

  // debugPrint(body.toString());
  await http.put(
    Uri.parse(API_LINK+"api/student/interests"),
    headers: {
      "x-auth-token" : token,
      "content-type":"application/json"
    },
    body: body
  )
  .then((v) async {
    // debugPrint("Response"+v.body.toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("student-interest",jsonEncode(interests));
    preferences.setString("student-interestCounts",jsonEncode(counts));
    // print("At the End of Then");
    check = true;
  })
  .catchError((err) {
    debugPrint(err);
    check = false;
  });
  // print("At the End");
  return check;
}


