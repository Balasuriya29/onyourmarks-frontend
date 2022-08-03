import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Student/profileAPIs.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Utilities/components.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';
import 'package:onyourmarks/Pages/Teachers/MyStudents.dart';
import 'package:onyourmarks/Pages/Teachers/ProfileTeacher.dart';
import 'package:onyourmarks/staticNames.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Center(child: Text("Teacher Home Page"),),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExamViewPage()));
              },
              child: Text("Marks"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Text("Profile"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyStudents()));
              },
              child: Text("My Students"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getTeacherMe();
  }
}
