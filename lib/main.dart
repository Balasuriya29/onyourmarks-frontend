import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Pages/Teachers/TeacherHome.dart';
import 'package:onyourmarks/staticNames.dart';

import 'Components/components.dart';
import 'Pages/Students/StudentCard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  var pages = [StudentCard(), TeacherHome()];
  var pagesName = [Text("Student Details Page"), Text("Teacher Home Page")];

  @override
  void initState() {
    super.initState();
    meFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Container(
        height: 500,
        child: ListView.separated(itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => pages.elementAt(index)));
                },
              child: Container(
                  height: 60,
                  width: 500,
                  color: Colors.black12,
                  child: Center(child: pagesName.elementAt(index))),
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 10,
          );
        }, itemCount: pages.length,),
      ),

    );
  }
}


