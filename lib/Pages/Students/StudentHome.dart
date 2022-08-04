import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/Students/Academics/MyExams.dart';
import 'package:onyourmarks/Pages/Students/Academics/MyMarks.dart';
import 'package:onyourmarks/Pages/Students/CCA/MyCCA.dart';
import 'package:onyourmarks/Pages/Students/Profile/MyTeachers.dart';
import 'package:onyourmarks/Utilities/components.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:onyourmarks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiHandler/Student/profileAPIs.dart';
import '../HomePage.dart';
import 'Chat/ChatPage.dart';

import 'Profile/MyDetails.dart';

class StudentHomeM extends StatelessWidget {
  const StudentHomeM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const StudentHome(0),
    );
  }
}

class StudentHome extends StatefulWidget {
  final index;
  const StudentHome(this.index,{Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  var pages = [HomePage(), MyTeachers(), MyExams(), MyMarks(), MyCCA()];
  var index;
  var me;
  bool isFetching = true;

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("student-personalDetails").toString());
    // print(me);
    setState(() {
      isFetching = false;
      index = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: getAppBar(APP_NAME),
      body: pages[index ?? 0],
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDetails()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
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
                        (isFetching)?Text("Roll No"):getTheStyledTextForExamsList(me["roll_no"], 17.5),
                        (isFetching)?Text("Name"):getTheStyledTextForExamsList(me["first_name"]+" "+me["last_name"], 17.5),
                        placeASizedBoxHere(20)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            index = 0;
                          });
                        },
                        child: getsideCards(Icon(CupertinoIcons.home) , 'Home', context)
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            index = 1;
                          });
                        },
                        child: getsideCards(Icon(CupertinoIcons.person_crop_rectangle_fill) , 'My Class Teachers', context)
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            index = 2;
                          });
                        },
                        child: getsideCards(Icon(CupertinoIcons.pencil) , 'My Exams', context)
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            index = 3;
                          });
                        },
                        child: getsideCards(Icon(Icons.check_circle) , 'My Marks', context)
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            index = 4;
                          });
                        },
                        child: getsideCards(Icon(Icons.format_list_numbered_rounded) , 'My CCA', context)
                    ),
                  ],
                ),
              ),

              GestureDetector(
                  onTap: (){

                  },
                  child: getsideCards(Icon(Icons.settings) , 'Settings', context)
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: getsideCards(Icon(Icons.logout) , 'Log Out', context)
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
    getStudentMe();
    getMyInfo();
  }
}
