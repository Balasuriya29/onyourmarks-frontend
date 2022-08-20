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
  List<TeacherModel> teachersToShow = [];
  var isFetching = true;
  var isSearchButtonClicked = false;

  getMyTeachersFunc() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stdId = jsonDecode(preferences.get("student-personalDetails").toString())["std_id"]["_id"].toString();
    teachers = await getMyTeachers(stdId);
    teachersToShow = teachers;
    (mounted)?setState(() {
      isFetching = false;
    }):null;
  }

  changeList(String s){
    List<TeacherModel> newTeachers = [];
    for(var i in teachers){
      if(i.name?.toLowerCase().contains(s.toLowerCase()) ?? false){
        newTeachers.add(i);
      }
    }
    teachersToShow = newTeachers;
    (mounted)?setState(() {

    }):null;
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
      customPaddedRowWidget(Row(
        children: [
          Expanded(
            flex:2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 30,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Teachers",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("STANDARD : "+widget.standard.toString(), style: TextStyle(
                    fontSize: 14
                ),)
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex:2,
                  child: IconButton(
                    onPressed: (){
                      isSearchButtonClicked = !isSearchButtonClicked;
                      (mounted)?setState(() {
                        teachersToShow = teachers;
                      }):null;
                    } , icon: Icon(Icons.search_rounded)
                  ),
                ),
                Expanded(
                  // flex:2,
                  child: IconButton(
                    onPressed: (){

                    } , icon: Icon(Icons.more_vert)
                  ),
                )
              ],
            ),
          )
        ],
      ),10),

      (isSearchButtonClicked)
        ?Column(
        children: [
          placeASizedBoxHere(20),
          customPaddedRowWidget(TextField(
            onChanged: (s){
              changeList(s);
            },
            decoration:InputDecoration(
              suffixIcon:IconButton(
                  onPressed: (){

                  } , icon: Icon(Icons.search_rounded)
              ) ,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40)
                )
            ),
          ), 15)
        ],
      )
        :Text(""),
      placeASizedBoxHere(10),
      (isFetching)
        ?loadingPage()
        :Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              return ExpansionTile(
                title: Text(teachersToShow.elementAt(index).id ?? ""),
                children: <Widget>[
                  ListTile(title: Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name : ${teachersToShow.elementAt(index).name}"),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Subject : ${getSubjectName(teachersToShow.elementAt(index).subject?.subName ?? "")}"),
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
          }, itemCount: teachersToShow.length),
        ),
      ]
    );
  }
}
