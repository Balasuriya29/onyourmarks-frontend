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

  var pages = [HomePage(), MyStudents(), ExamViewPage()];
  var index;
  var me;
  bool isFetching = true;

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("teacher-personalDetails").toString());
    var today = DateTime.now();
    var date = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0);
    
    if(today.compareTo(date) == 1){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(today.toString().substring(0,10), true.toString());
    }
    setState(() {
      isFetching = false;
      index = widget.index;
    });
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
                      (isFetching)?Text("Id"):getTheStyledTextForExamsList(me["facultyId"], 17.5),
                      (isFetching)?Text("Name"):getTheStyledTextForExamsList(me["name"], 17.5),
                      placeASizedBoxHere(20)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                            onTap: (){
                              setState(() {
                                index = 0;
                              });
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
                              setState(() {
                                index = 1;
                              });
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
                              setState(() {
                                index = 2;
                              });
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: getsideCards(Icon(CupertinoIcons.pencil) , 'Update Student Exams', context)
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
            getBottomDrawerNavigation(context)
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

