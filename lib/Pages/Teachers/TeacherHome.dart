import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Pages/Teachers/Attendance/CalendarTeacher.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';
import 'package:onyourmarks/Pages/Teachers/MyStudents.dart';
import 'package:onyourmarks/Pages/Teachers/ProfileTeacher.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/Components/functional.dart';
import '../HomePage.dart';
import '../Teachers/Chat/ChatPage.dart';
import 'Academics/HomeWorkUpdate.dart';

class TeacherHomeM extends StatelessWidget {
  const TeacherHomeM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: const TeacherHome(0),
    );
  }
}

class TeacherHome extends StatefulWidget {
  final index;
  const TeacherHome(this.index,{Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {

  var pages = [HomePage(), MyStudents(), ExamViewPage(), HomeWorkUpdatePage()];
  var index;
  var me;
  Map<String, List<dynamic>>? map;
  bool isFetching = true;

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("teacher-personalDetails").toString());
    var standards = json.decode(preferences.getString("teacherStandardObjects") ?? " ");
    var subjects = json.decode(preferences.getString("teacherSubjectsObjects") ?? " ");

    map = {"Maths" : ["8-A", "9-B"]};

    for(var i = 0;i<subjects.length ;i++){
      var subName = getSubjectName(jsonDecode(subjects[i])["sub_name"]);
      var stds = map?[subName];
      var stdName = jsonDecode(standards[i])["std_name"];
      if(stds!=null){
        stds.add(stdName);
        map?[subName ?? ""] = stds;
      }
      else{
        map?[subName ?? ""] = [stdName];
      }
    }
    var today = DateTime.now();
    var date = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0);
    
    if(today.compareTo(date) == 1){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(today.toString().substring(0,10), true.toString());
    }
    (mounted)?setState(() {
      isFetching = false;
      index = widget.index;
    }):null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text(APP_NAME),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarForAttendance()));
            }, icon: Icon(Icons.perm_contact_calendar)
            ),
          )
        ],
      ),
      body: pages[index ?? 0],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(me, map)));
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: "ProfilePic",
                        child: CircleAvatar(
                          radius: 40,
                          child: Icon(
                            CupertinoIcons.profile_circled,
                            size: 70,
                          ),
                        ),
                      ),
                      placeASizedBoxHere(20),
                      (isFetching)?Text("Id"):getTheStyledTextForExamsList(me["facultyId"], 17.5,Colors.white),
                      (isFetching)?Text("Name"):getTheStyledTextForExamsList(me["name"], 17.5,Colors.white),
                      placeASizedBoxHere(20)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 3),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                            onTap: (){
                              (mounted)?setState(() {
                                index = 0;
                              }):null;
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: getsideCards(Icon(CupertinoIcons.home) , 'Home', context)
                        );
                      }
                    ),
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                            onTap: (){
                              (mounted)?setState(() {
                                index = 1;
                              }):null;
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: getsideCards(Icon(CupertinoIcons.person_crop_rectangle_fill) , 'My Class Students', context)
                        );
                      }
                    ),
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                            onTap: (){
                              (mounted)?setState(() {
                                index = 2;
                              }):null;
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: getsideCards(Icon(CupertinoIcons.pencil) , 'Update Student Exams', context)
                        );
                      }
                    ),
                    Builder(
                        builder: (context) {
                          return GestureDetector(
                              onTap: (){
                                (mounted)?setState(() {
                                  index = 3;
                                }):null;
                                Scaffold.of(context).openEndDrawer();
                              },
                              child: getsideCards(Icon(Icons.work_history_sharp) , 'Update Homework', context)
                          );
                        }
                    ),
                    getBottomDrawerNavigation(context)
                  ],
                ),
              ),

            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.chat_bubble_text_fill),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>mychats()));
        },
      ),
    );
  }

  @override
  void initState() {
    getTeacherMe().then((v) => getMyInfo());
  }
}

