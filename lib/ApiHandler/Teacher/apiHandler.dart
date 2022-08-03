import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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


Future<List<StudentModel>> getStudentsWithoutChat() async{
  List<StudentModel> studentsList = [];
  var res = await http.get((Uri.parse(API_LINK+"api/teacher/students-without-chat")),
      headers: {
        "x-auth-token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkMzk0Mjg4MWQ3ZmYwNjA4NzU4YmMiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMDE0Mn0.bnwWRCfVJ5Wd0-g3RfX9sR3J4ms8sIrYN1ripU6pWGU",
        "content-type" : "application/json"
      }
  );
  var students = json.decode(res.body);
  for(var i in students){
    StudentModel student = new StudentModel(i["first_name"]+" "+i["last_name"],i["roll_no"],i["_id"]);
    studentsList.add(student);
  }
  return studentsList;
  debugPrint(res.body);
}

postNewChat(String teacher_id,String student_id) async{
  var body = {
    "teacher_id" : teacher_id,
    "student_id" : student_id,
  };
  await http.post(Uri.parse(API_LINK+"api/chat/"),
    body: json.encode(body),
    headers: {
      "content-type":"application/json",
      "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkMzk0Mjg4MWQ3ZmYwNjA4NzU4YmMiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMDE0Mn0.bnwWRCfVJ5Wd0-g3RfX9sR3J4ms8sIrYN1ripU6pWGU"
    },
  ).then((value) {
    print("Chat added");
  });
}

postMessage(String message,String chat_id,String person) async{
  CollectionReference ref =  await FirebaseFirestore.instance.collection("message");
  var body = {
    "message":message,
    "chat_id":chat_id,
    "person":person,
    "time" : DateTime.now().millisecondsSinceEpoch.toString()
  };
  ref.add(body).then((value){
    print(value);
    print("Added");
  });
}


Future<List<StudentModel>> getMyChats() async{
  List<StudentModel> students = [];
  var res  = await http.get(Uri.parse(API_LINK+"api/teacher/mychat"),
    headers: {
      "content-type":"application/json",
      "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0"
    },
  );
  debugPrint(res.body);
  var studentsRes = json.decode(res.body);
  for(var i in studentsRes){
    StudentModel student = new StudentModel.forChat(i["student_id"]["_id"], i["student_id"]["first_name"],i["_id"]);
    students.add(student);
  }
  // debugPrint(res.body);
  return students;
}