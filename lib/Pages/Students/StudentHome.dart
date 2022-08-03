import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ApiHandler/Student/profileAPIs.dart';
import 'Academics/GetStudentInterest.dart';
import 'Academics/MyExams.dart';
import 'Academics/MyMarks.dart';
import 'CCA/CCAForm.dart';
import 'CCA/MyCCA.dart';
import 'Chat/ChatPage.dart';
import 'Profile/ProfileStudent.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Student Home Page"),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileStudent()));
              }, child: Text("Profile")
            ),
            TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentCCAForm()));
              }, child: Text("CCA Form")
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCCA()));
            }, child: Text("My CCA")
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStudentInterest()));
            }, child: Text("Get Interest")
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyExams()));
            }, child: Text("My Exams")
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMarks()));
            }, child: Text("My Marks")
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
  }
}
