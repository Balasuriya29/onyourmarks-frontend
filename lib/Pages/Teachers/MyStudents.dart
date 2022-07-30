import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Components/components.dart';
import 'package:onyourmarks/staticNames.dart';

class MyStudents extends StatefulWidget {
  const MyStudents({Key? key}) : super(key: key);

  @override
  State<MyStudents> createState() => _MyStudentsState();
}

class _MyStudentsState extends State<MyStudents> {
  List<Map<String,dynamic>>? students;
  var isFetching = true;

  getStudents() async {
    students = await getMyAllStudents();
    setState(() {
      isFetching = false;
    });
    // print(students);
  }

  @override
  void initState() {
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0,top: 30.0,right: 30.0,bottom: 15.0),
            child: Text(
              "Your Students 👨‍🎓👩‍🎓",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          (isFetching)
          ?loadingPage()
          :Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
            return ExpansionTile(
              title: Text(students?.elementAt(index)["roll_no"]),
              children: <Widget>[
                    ListTile(title: Row(
                      children: [
                        Expanded(
                            flex:2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name : " + students?.elementAt(index)["first_name"] + " " + students?.elementAt(index)["last_name"]),
                                placeASizedBoxHere(20),
                                Text("Class : "+students?.elementAt(index)["std_id"]["std_name"]),
                              ],
                            )),
                        Expanded(
                            flex:2,
                            child: Text("")),
                        Expanded(
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(
                                CupertinoIcons.profile_circled,
                            size: 75),
                          ),
                        )
                      ],
                    )),

              ],
            );
                }, separatorBuilder: (BuildContext context, int index){
            return placeASizedBoxHere(0);
                }, itemCount: students?.length ?? 0),
          )
        ],
      ),
    );
  }
}
