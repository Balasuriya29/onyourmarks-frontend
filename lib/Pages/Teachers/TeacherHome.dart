import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Components/components.dart';
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
}
