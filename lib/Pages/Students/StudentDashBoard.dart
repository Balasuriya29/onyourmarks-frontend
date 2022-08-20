import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Student/StudentsAPIs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ApiHandler/Student/CCAAPIs.dart';
import '../../Models/Student Models/MarksModel.dart';
import '../../Utilities/Components/class.dart';
import '../../Utilities/Components/functional.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  //Page 1
  Map<String, dynamic>? me;
  var isFetchingPage1 = true;
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

    (mounted)?setState(() {
      isFetchingPage1 = false;
      // print("Got Info");
    }):null;
  }

  //Page 2
  Map<String, List<MarksModel>> marksMap = {};
  Map<String, List<MarksModel>> currentMarks = {};
  var isFetchingPage2 = true;
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
        (mounted)?setState(() {}):null;
        break;
      }
    }
    (mounted)?setState(() {
      isFetchingPage2 = false;
      // print("Got Marks");
    }):null;
  }

  //Page 3
  var isFetchingPage3 = true;
  var activities;

  getCCA() async {
    activities = await getMyActivities();
    (mounted)?setState(() {
      isFetchingPage3 = false;
      // print("Got CCA");
    }):null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
        children : [
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
                          "DASHBOARD",
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
                    Text("INDIVIDUAL STUDENT ANALYSIS")
                  ],
                ),
              ),
              (isFetchingPage1)?Text(""):Expanded(
                child: CircleAvatar(
                  minRadius: 30,
                  child: Text(valuesName[0].substring(0,1).toUpperCase(), style: TextStyle(
                      fontSize: 30
                  ),),
                ),
              )
            ],
          ),10),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?loadingPage()
              :StudentDashBoard_1(me: me, isFetchingPage1: isFetchingPage1, fieldsName: fieldsName, keysOfMe: keysOfMe, valuesName: valuesName,),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?Text("")
              :StudentDashBoard_2(currentMarks: currentMarks, gotCards: gotCards, isFetchingPage2: isFetchingPage2, marksMap: marksMap, me: me),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?Text("")
              :StudentDashBoard_3(activities: activities,currentMarks: currentMarks,isFetchingCCA: isFetchingPage3,)
        ]
      ),
    );
  }

  @override
  void initState() {
    getMyInfo()
        .then((v1) => getMarks())
        .then((v2) => getCCA());
  }
}

class StudentDashBoard_1 extends StatefulWidget {
  const StudentDashBoard_1({
    Key? key,
    required this.me,
    required this.isFetchingPage1,
    required this.keysOfMe,
    required this.fieldsName,
    required this.valuesName,
  }) : super(key: key);
  final me;
  final isFetchingPage1;
  final keysOfMe;
  final fieldsName;
  final valuesName;
  @override
  State<StudentDashBoard_1> createState() => _StudentDashBoard_1State();
}

class _StudentDashBoard_1State extends State<StudentDashBoard_1> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          customPaddedRowWidget(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex:4,
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
              Expanded(
                flex:5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 200,
                      // color: Colors.red,
                      child: SfCircularChart(
                        title: ChartTitle(text: 'Attendance Percentage',textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        series: getSemiDoughnutSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    )
                  ],
                ),
              )
            ],
          ), 10),
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
                    getTableRow(
                        Text(widget.fieldsName[i] ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.valuesName[i] ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                        "start", "start"
                    )
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
  const StudentDashBoard_2({
    Key? key,
    required this.me,
    required this.gotCards,
    required this.isFetchingPage2,
    required this.currentMarks,
    required this.marksMap,
  }) : super(key: key);
  final me;
  final gotCards;
  final isFetchingPage2;
  final currentMarks;
  final marksMap;
  @override
  State<StudentDashBoard_2> createState() => _StudentDashBoard_2State();
}

class _StudentDashBoard_2State extends State<StudentDashBoard_2> {

  getTotalMark(List<MarksModel> list){
    var total = 0;
    for(var i in list){
      total = total + int.parse(i.obtained_marks ?? "0");
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeASizedBoxHere(30),
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
                      Text(widget.currentMarks.keys.first.toString().toUpperCase(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5
                      ),),
                      placeASizedBoxHere(30),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(("NAME        : "+widget.me["first_name"]+" "+widget.me["last_name"]).toUpperCase(), style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                        ),),
                      ),
                      placeASizedBoxHere(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text("ROLL NO : "+widget.me["roll_no"], style: TextStyle(
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
                      CircularChart(widget.currentMarks.values.first),
                      placeASizedBoxHere(20),
                      Text((getTotalMark(widget.currentMarks.values.first)).toString() + "/" + (100*widget.currentMarks.values.first.length).toString(),style: TextStyle(
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
            BarChartForStudentsMark(marks: widget.currentMarks.values.first),10
        ),
        placeASizedBoxHere(50)
      ],
    );
  }

}

class StudentDashBoard_3 extends StatefulWidget {
  const StudentDashBoard_3({
    Key? key,
    required this.activities,
    required this.isFetchingCCA,
    required this.currentMarks
  }) : super(key: key);
  final activities;
  final isFetchingCCA;
  final currentMarks;
  @override
  State<StudentDashBoard_3> createState() => _StudentDashBoard_3State();
}

class _StudentDashBoard_3State extends State<StudentDashBoard_3> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customPaddedRowWidget( Text("PERFORMANCE",style: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.bold
        ),), 10),
        MultiColoredChartForDashBoard(widget.currentMarks),
        placeASizedBoxHere(20),
        BarChartForCCA(widget.activities),
        placeASizedBoxHere(20),
      ],
    );
  }
}





