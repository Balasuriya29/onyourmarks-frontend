import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/Students/Academics/HomeWork.dart';
import 'package:onyourmarks/Pages/Students/Academics/MyExams.dart';
import 'package:onyourmarks/Pages/Students/Academics/MyMarks.dart';
import 'package:onyourmarks/Pages/Students/Attendance/CalendarStudent.dart';
import 'package:onyourmarks/Pages/Students/CCA/MyCCA.dart';
import 'package:onyourmarks/Pages/Students/Profile/MyTeachers.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiHandler/Student/profileAPIs.dart';
import '../../Utilities/Components/functional.dart';
import '../HomePage.dart';
import 'Academics/TimeTable.dart';
import 'Chat/ChatPage.dart';

import 'Profile/MyDetails.dart';
import 'StudentDashBoard.dart';

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
  var pages = [HomePage(role: "Student",),StudentDashboard(), MyExams(), MyMarks(), MyCCA(), ScheduleSystem(), HomeWorkPage()];
  var index;
  var me;
  bool isFetching = true;

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("student-personalDetails").toString());

    pages.insert(2, MyTeachers(me["std_id"]["std_name"]));

    setState(() {
      isFetching = false;
      index = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future<bool>? _onBackPressed(BuildContext context) {
    //   return showDialog(
    //     context: context,
    //     builder: (context) => new AlertDialog(
    //       title: new Text('Are you sure?'),
    //       content: new Text('Do you want to exit an App'),
    //       actions: <Widget>[
    //         new GestureDetector(
    //           onTap: () => Navigator.of(context).pop(false),
    //           child: Text("NO"),
    //         ),
    //         SizedBox(height: 16),
    //         new GestureDetector(
    //           onTap: () => Navigator.of(context).pop(true),
    //           child: Text("YES"),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    bool shouldPop = false;
    return WillPopScope(
        onWillPop: () async {
          if(index == 0){
            return true;
          }
          else{
            index = 0;
            setState(() {

            });
          }
          return shouldPop;
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text(texts[0]),
          actions:[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarForAttendanceView()));
              }, icon: Icon(Icons.perm_contact_calendar)
              ),
            )
          ],
        ),
        body: (isFetching)
          ?loadingPage()
          :Builder(
            builder: (context) {
              return GestureDetector(
                onPanUpdate: (details) {
                  // Swiping in right direction.
                  if (details.delta.dx > 0) {
                    Scaffold.of(context).openDrawer();
                  }

                  // Swiping in left direction.
                  if (details.delta.dx < 0) {}
                },
                child: pages[index]
        );
            }
          ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => MyDetails(me)
                        ),
                      );
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
                              tag: texts[69],
                              child: CircleAvatar(
                                radius: 40,
                                  child: Icon(
                                      CupertinoIcons.profile_circled,
                                      size: 70,
                                  ),
                                ),
                            ),
                            placeASizedBoxHere(20),
                            (isFetching)?Text(texts[70]):getTheStyledTextForExamsList(me["roll_no"], 17.5,Colors.white),
                            (isFetching)?Text(texts[71]):getTheStyledTextForExamsList(me["first_name"]+" "+me["last_name"], 17.5,Colors.white),
                            placeASizedBoxHere(20),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 3),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SingleChildScrollView(
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
                                child: getsideCards(Icon(CupertinoIcons.home) , texts[4], context)
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
                                child: getsideCards(Icon(Icons.dashboard) ,texts[72], context)
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
                                child: getsideCards(Icon(CupertinoIcons.person_crop_rectangle_fill) , texts[73], context)
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
                                child: getsideCards(Icon(CupertinoIcons.pencil) , texts[74], context)
                            );
                          }
                        ),
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                                onTap: (){
                                  (mounted)?setState(() {
                                    index = 4;
                                  }):null;
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: getsideCards(Icon(Icons.check_circle) , texts[75], context)
                            );
                          }
                        ),
                        Builder(
                            builder: (context) {
                              return GestureDetector(
                                  onTap: (){
                                    (mounted)?setState(() {
                                      index = 5;
                                    }):null;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child: getsideCards(Icon(Icons.format_list_numbered_rounded) , texts[76], context)
                              );
                            }
                        ),
                        Builder(
                            builder: (context) {
                              return GestureDetector(
                                  onTap: (){
                                    (mounted)?setState(() {
                                      index = 6;
                                    }):null;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child: getsideCards(Icon(Icons.schedule) ,texts[77] , context)
                              );
                            }
                        ),
                        Builder(
                            builder: (context) {
                              return GestureDetector(
                                  onTap: (){
                                    (mounted)?setState(() {
                                      index = 7;
                                    }):null;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child: getsideCards(Icon(Icons.work) ,texts[78], context)
                              );
                            }
                        ),
                        Builder(
                            builder: (context) {
                              return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarForAttendanceView()));
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child: getsideCards(Icon(CupertinoIcons.calendar_today) , texts[79], context)
                              );
                            }
                        ),
                        getBottomDrawerNavigation(context),                    ],
                    ),
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
      ),
    );
  }

  @override
  void initState() {
    index = widget.index;
    getStudentMe().then((v) => getMyInfo());
  }
}
