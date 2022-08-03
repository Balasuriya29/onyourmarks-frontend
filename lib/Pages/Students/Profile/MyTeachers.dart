import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiHandler/Student/profileAPIs.dart';
import '../../../Utilities/components.dart';
import '../../../Models/Student Models/TeacherModel.dart';

class MyTeachers extends StatefulWidget {
  const MyTeachers({Key? key}) : super(key: key);

  @override
  State<MyTeachers> createState() => _MyTeachersState();
}

class _MyTeachersState extends State<MyTeachers> {

  List<TeacherModel> teachers = [];
  var isFetching = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("My Teachers"),
      body: Column(
          children: [
              Padding(
              padding: const EdgeInsets.only(left: 30.0,top: 30.0,right: 30.0,bottom: 15.0),
              child: Text(
                "Your Teachers 👨‍🏫👩‍🏫",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    (isFetching)
          ?Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  CircularProgressIndicator(),
                  SizedBox(
                  height: 20,
                  ),
                Text("Loading Data")
              ],
            ))
          :Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  return ExpansionTile(
                    title: Text(teachers.elementAt(index).id ?? ""),
                    children: <Widget>[
                      ListTile(title: Row(
                        children: [
                          Expanded(
                              flex:2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name : ${teachers.elementAt(index).name}"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Subject : ${teachers.elementAt(index).subject?.subName}"),
                                ],
                              )),
                          Expanded(
                              flex:1,
                              child: Text("")),
                          Expanded(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                  CupertinoIcons.profile_circled,
                                  size: 90),
                            ),
                          )
                        ],
                      )),

                    ],
                  );
                }, separatorBuilder: (BuildContext context, int index){
              return SizedBox( height: 0,);
            }, itemCount: teachers.length),
          ),
        ]
      )
    );
  }

  getMyTeachersFunc() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stdId = jsonDecode(preferences.get("personalDetails").toString())["std_id"]["_id"].toString();
    teachers = await getMyTeachers(stdId);
    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    getMyTeachersFunc();
  }
}
