import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:onyourmarks/Models/StudentModel.dart';
import 'package:onyourmarks/Models/SubjectModel.dart';
import 'package:onyourmarks/Models/ExamModel.dart';
import 'package:http/http.dart' as http;
import 'package:onyourmarks/staticNames.dart';

Future<List<ExamModel>> getExams() async{
    List<ExamModel> exams = [];
    
    var res = await http.get(
        Uri.parse(API_LINK+"api/teacher/getexams"),
        headers: {
            "x-auth-token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0"
        }
    );
    var exam = await json.decode(res.body);

    for(var i in exam) {
      if (!(i.toString() == "[]")) {
        for (var j in i) {
          int index = 0;
          List<SubjectModel> subjects = [];
          for (var k in j["exam_id"]["subjects"]) {
            SubjectModel sm = SubjectModel(
              k["_id"],
              k["sub_name"],
              k["total_marks"].toString(),
              j["exam_id"]["dates"][index++].toString()
            );
            subjects.add(sm);
          }

          ExamModel em = ExamModel(
              j["exam_id"]["_id"].toString(),
              j["std"]["_id"].toString(),
              j["exam_id"]["exam_name"].toString(),
              j["std"]["std_name"].toString(),
              subjects,
              j["exam_id"]["status"]
          );
          exams.add(em);
        }
      }
    }
    return exams;
}

Future<List<StudentModel>> getStudentsOfGivenSTD(String std_id) async{
  List<StudentModel> students = [];

  var res = await http.get(
      Uri.parse(API_LINK+"api/teacher/mystudents/"+std_id),
      headers: {
        "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0"
      }
  );
  var student = json.decode(res.body);

  student = student[0];
  for(var i in student){
    var student_obj = StudentModel(i["first_name"]+" "+i["last_name"], i["roll_no"], i["_id"]);
    students.add(student_obj);
  }

  return students;
}

void postStudentMarks(String student_id,String exam_id,String subject_id,int obtained) async{
  var body = json.encode({
    "exam_id":exam_id,
    "subject_id":subject_id,
    "student_id":student_id,
    "obtained":obtained
  });
  await http.post(
      Uri.parse(API_LINK+"api/teacher/marks/"+student_id),
      headers: {
        "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0",
        "content-type":"application/json"
      },
      body: body
  ).then((value) {
    // debugPrint(value.toString());
  })
  .catchError((err){
    debugPrint(err);
  });
}

void meFunc() async {
  var res = await http.get(
    Uri.parse(API_LINK+"api/admin/me"),
    headers: {
      "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0",
    }
  );
  var me = json.decode(res.body);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("id", me[0]["_id"].toString());
  var teacherRelation = me[1];
  List<String> teacherSubjects = [];
  List<String> teacherSubjectsIds = [];
  List<String> teacherStandards = [];
  for(var i in teacherRelation){
    teacherSubjects.add(json.encode(i["subject_id"]));
    teacherStandards.add(json.encode(i["std_id"]));
    teacherSubjectsIds.add(i["subject_id"]["_id"]);
  }
  preferences.setString("personalDetails", json.encode(me[0]));
  preferences.setString("teacherSubjects", json.encode(teacherSubjectsIds));
  preferences.setString("teacherSubjectsObjects", json.encode(teacherSubjects));
  preferences.setString("teacherStandardObjects", json.encode(teacherStandards));
}

Future<List<Map<String,dynamic>>> getMyAllStudents() async {
  List<Map<String,dynamic>> students = [];
  var res = await http.get(
      Uri.parse(API_LINK+"api/teacher/mystudents/All"),
      headers: {
        "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0",
      }
  );
  var value = json.decode(res.body);
  for(var i in value){
    for(var j in i){
      students.add(j);
    }
  }

  return students;
}