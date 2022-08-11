import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Student/StudentsAPIs.dart';
import 'package:onyourmarks/Utilities/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Student Models/MarksModel.dart';

var globalScrollController = ScrollController();

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffe3e3),
      body: ListView(
        controller: globalScrollController,
        children : [
          StudentDashBoard_1(),
          StudentDashBoard_2(),
        ]
      ),
    );
  }
}

class StudentDashBoard_1 extends StatefulWidget {
  const StudentDashBoard_1({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard_1> createState() => _StudentDashBoard_1State();
}

class _StudentDashBoard_1State extends State<StudentDashBoard_1> {

  Map<String, dynamic>? me;
  var isFetching = true;
  List<String>? keysOfMe = [];


  var fieldsName = ["NAME","ROLL NO","STANDARD","GENDER","FATHER NAME","ADDRESS","PHONE NO"];
  var valuesName = ["","roll_no","std_id","gender","parent1name","currentAddress","phoneNo"];

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("student-personalDetails").toString());
    keysOfMe = me?.keys.toList();
    var fName = me?["first_name"].toString() ?? "";
    var lName = me?["last_name"].toString() ?? "";
    valuesName[0] = fName+""+lName;
    for(var i in keysOfMe!){
      if(valuesName.contains(i)){
        int _index = valuesName.indexOf(i);
        if(i == "std_id"){
          valuesName[_index] = me?[i]["std_name"].toString() ?? "";
          continue;
        }
        valuesName[_index] = me?[i].toString() ?? "";
      }
    }

    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    getMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return (isFetching)
        ?loadingPage()
        :Column(
          children: [
            SizedBox(
              height: 50,
            ),
            customPaddedRowWidget(Row(
              children: [
                Expanded(
                  flex:4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 30,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "PROFILE",
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
                      Text("STUDENT DASHBOARD INDIVIDUAL")
                    ],
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                    minRadius: 30,
                    child: Text(valuesName[0].substring(0,1).toUpperCase(), style: TextStyle(
                      fontSize: 30
                    ),),
                  ),
                )
              ],
            ),10),
            SizedBox(
              height: 40,
            ),
            customPaddedRowWidget(Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  flex:5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 175,
                          width: 50,
                          color: Colors.transparent,
                          child: Image.asset('Images/DashBoard-Image.png')
                        ),
                      ),

                    ],
                  )
                ),
                Expanded(child: Text("")),
                Expanded(
                  flex:5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Attendance Percentage", style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                )
              ],
            ), 10),
            SizedBox(
              height: 40,
            ),
            customPaddedRowWidget(Column(
              children: [
                Table(
                  border: TableBorder.all(
                      borderRadius: BorderRadius.circular(5),
                      width: 1.25
                  ),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                    4: FlexColumnWidth(),
                    5: FlexColumnWidth(),
                    6: FlexColumnWidth(),
                    7: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    for(var i=0;i<7;i++)
                      getTableRow(fieldsName[i],valuesName[i])
                  ],
                )
              ],
            ),10),
            SizedBox(
              height: 40,
            ),
          ],
        );
  }
}

class StudentDashBoard_2 extends StatefulWidget {
  const StudentDashBoard_2({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard_2> createState() => _StudentDashBoard_2State();
}

class _StudentDashBoard_2State extends State<StudentDashBoard_2> {
  Map<String, List<MarksModel>> marksMap = {};
  Map<String, List<MarksModel>> currentMarks = {};
  var me;
  var isFetching = true;
  var gotCards = false;
  var mySubjectLength;

  getMarks() async {
    marksMap = await getMyMarks();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var me = jsonDecode(preferences.getString("student-personalDetails").toString());
    mySubjectLength = me["std_id"]["subject_id"].length;
    var marksObjects = marksMap.values.toList();
    var marksExams = marksMap.keys.toList();
    for(var i = marksObjects.length - 1;i>=0;i--){
      if(marksObjects.elementAt(i).length == mySubjectLength){
        currentMarks[marksExams.elementAt(i)] = marksObjects.elementAt(i);
        setState(() {});
        break;
      }
    }
    setState(() {
      isFetching = false;
    });
  }

  getTotalMark(List<MarksModel> list){
    var total = 0;
    for(var i in list){
      total = total + int.parse(i.obtained_marks ?? "0");
    }

    return total;
  }

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("student-personalDetails").toString());
  }

  @override
  void initState() {
    getMyInfo().then((v) => getMarks());
  }

  @override
  Widget build(BuildContext context) {
    return (isFetching)
        ?loadingPage()
        :Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeASizedBoxHere(50),
        customPaddedRowWidget(
            Row(
              children: [
                Expanded(
                  flex:4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CURRENT EXAM STATUS", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),),
                      placeASizedBoxHere(20),
                      Text("HALF YEARLY EXAMINATION", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5
                      ),),
                      placeASizedBoxHere(30),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(("NAME        : "+me["first_name"]+" "+me["last_name"]).toUpperCase(), style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                        ),),
                      ),
                      placeASizedBoxHere(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text("ROLL NO : "+me["roll_no"], style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                        ),),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircularChart(currentMarks.values.first),
                      placeASizedBoxHere(20),
                      Text((getTotalMark(currentMarks.values.first)).toString() + "/" + (100*currentMarks.values.first.length).toString(),style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                )
              ],
            ),10
        ),
        placeASizedBoxHere(25),
        customPaddedRowWidget(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getAllStackSubjects(currentMarks),
            ),10
        ),
        placeASizedBoxHere(50)
      ],
    );
  }

}

