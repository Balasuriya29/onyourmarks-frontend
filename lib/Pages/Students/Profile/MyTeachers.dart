import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiHandler/Student/profileAPIs.dart';
import '../../../Models/Student Models/TeacherModel.dart';

class MyTeachers extends StatefulWidget {
  const MyTeachers(this.standard,{
    Key? key,
  }) : super(key: key);
  final standard;

  @override
  State<MyTeachers> createState() => _MyTeachersState();
}

class _MyTeachersState extends State<MyTeachers> {
  List<TeacherModel> teachers = [];
  var isFetching = true;

  getMyTeachersFunc() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stdId = jsonDecode(preferences.get("student-personalDetails").toString())["std_id"]["_id"].toString();
    teachers = await getMyTeachers(stdId);
    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    getMyTeachersFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      placeASizedBoxHere(50),
      getHeader("Teachers", "CLASS : "+widget.standard.toString()),
      placeASizedBoxHere(20),
      (isFetching)
        ?loadingPage()
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
                            Text("Subject : ${getSubjectName(teachers.elementAt(index).subject?.subName ?? "")}"),
                          ],
                        )
                      ),
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
    );
  }
}
