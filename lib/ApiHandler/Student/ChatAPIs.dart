import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../Utilities/functions.dart';
import '../../Models/Student Models/ChatModel.dart';
import '../../Models/Student Models/TeacherModel.dart';
import '../../staticNames.dart';


Future<List<TeacherModel>> getTeachersWithoutChat() async{
  var token = await getToken();
  List<TeacherModel> teachersWithoutChat= [];
  // debugPrint("In func");
  var res = await http.get(
      Uri.parse("${API_LINK}api/student/teachers-without-chat"),
      headers: {
        "content-type":"application/json",
        "x-auth-token":token
      },
  );
  // debugPrint(res.body);
  var teachers =await json.decode(res.body.toString());
  for(var i in teachers){
     TeacherModel teacher = TeacherModel.fromJson(i);
     // debugPrint(teacher.name);
     teachersWithoutChat.add(teacher);
  }
  return teachersWithoutChat;
}


Future<List<TeacherModel>> getMyChats() async{
  var token = await getToken();
  List<TeacherModel> teachers = [];
  var res  = await http.get(Uri.parse("${API_LINK}api/student/mychat"),
    headers: {
      "content-type":"application/json",
      "x-auth-token":token
    },
  );
  var teachersRes = json.decode(res.body);
  for(var i in teachersRes){
    TeacherModel teacher = new TeacherModel.forChat(i["teacher_id"]["_id"], i["teacher_id"]["name"],i["_id"]);
    teachers.add(teacher);
  }
  // debugPrint(res.body);
  return teachers;
}

Future<List<Chat>> getMessagesFromFB1(String chat_id) async{
  List<Chat> messages = [];
  if(chat_id == null){
    return <Chat>[];
  }
  CollectionReference ref = await FirebaseFirestore.instance.collection("message");
  var res = await ref.where("chat_id",isEqualTo: chat_id).snapshots();
  res.listen((event) async{
    var iter =await event.docs.iterator;
    while(iter.moveNext()){
      var data = iter.current.data() as Map<String,dynamic>;
      // print(data);
      Chat chat = new Chat(data["chat_id"], data["message"], data["person"]);
      // print(chat.message.runtimeType);
      messages.add(chat);
    }
  });
  print(messages.toString());
  return messages;

}

// Future<List<Chat>> getMessages(String chat_id) async{
//   await getMessagesFromFB(chat_id);
//
//
//   await http.get(Uri.parse(apiLink.apilink+"api/chat/${chat_id}"),
//     headers: {
//       "content-type":"application/json",
//       "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRlMzBjMWJjNmEzZGE3NjU5YjgxNmMiLCJyb2xlIjoiU3R1ZGVudCIsImlhdCI6MTY1ODcyMDE0Mn0.jYSIJMyP_Mf_dLtwJoa_sXMykc0ORVfdDBmuHMWEM84"
//     },
//   ).then((value){
//     //debugPrint(value.body.toString());
//     var messagesRes = json.decode(value.body);
//     for(var i in messagesRes){
//
//     }
//     // for(var j in messages){
//     //   print(j.message);
//     // }
//     //print(messages.toString());
//   });
//
// }

postNewChat(String teacher_id,String student_id) async{
  var token = await getToken();
  var body = {
    "teacher_id" : teacher_id,
    "student_id" : student_id,
  };
  await http.post(Uri.parse("${API_LINK}api/chat/"),
    body: json.encode(body),
    headers: {
      "content-type":"application/json",
      "x-auth-token":token
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

  // await http.post(Uri.parse(apiLink.apilink+"api/chat/message"),
  //   headers: {
  //     "content-type":"application/json",
  //     "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRlMzBjMWJjNmEzZGE3NjU5YjgxNmMiLCJyb2xlIjoiU3R1ZGVudCIsImlhdCI6MTY1ODcyMDE0Mn0.jYSIJMyP_Mf_dLtwJoa_sXMykc0ORVfdDBmuHMWEM84"
  //   },
  //   body: json.encode(body)
  // ).then((value) {
  //   print("Message posted");
  // });
}




