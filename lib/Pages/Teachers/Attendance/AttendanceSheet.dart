import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/AttendanceAPIs.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiHandler/Teacher/apiHandler.dart';
import '../../../Models/Teacher Models/StudentModel.dart';

class AttendanceSheet extends StatefulWidget {
  const AttendanceSheet({
    Key? key,
    required this.selectedDate
  }) : super(key: key);
  final selectedDate;
  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  var closedAttendance;
  var today;
  var selected;
  @override
  Widget build(BuildContext context) {
    return
      (today == selected)
        ?(closedAttendance == "true")
            ?AttendanceSheetFixed(selectedDate: widget.selectedDate)
            :AttendanceSheetToday(selectedDate: widget.selectedDate)
        :AttendanceSheetFixed(selectedDate: widget.selectedDate);
  }

  checkAttendance() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    closedAttendance = preferences.getString(widget.selectedDate.toString().substring(0,10));
    selected = widget.selectedDate.toString().substring(0,10);
    today = DateTime.now().toString().substring(0,10);
    (mounted)?setState(() {

    }):null;
  }

  @override
  void initState() {
    checkAttendance();
  }
}

class AttendanceSheetToday extends StatefulWidget {
  const AttendanceSheetToday({
    Key? key,
    required this.selectedDate
  }) : super(key: key);
  final selectedDate;

  @override
  State<AttendanceSheetToday> createState() => _AttendanceSheetTodayState();
}

class _AttendanceSheetTodayState extends State<AttendanceSheetToday> {
  List<StudentModel>? myStudents;
  var length = 0;
  var height = 0;
  var flags;
  var isFetching = true;
  var stdName = "";
  getMyAttendance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stdId = preferences.getString("class-Teacher");
    myStudents = await getAttendance(stdId!, widget.selectedDate);
    if(mounted){
      (mounted)?setState(() {

        length = myStudents?.length ?? 0;
        height = (length) * 60;
        flags = List.filled(length, true);
        stdName = myStudents?.elementAt(0).std_name ?? "";
        isFetching = false;
      }):null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: getAppBar(APP_NAME),
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            customPaddedRowWidget(Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 30,
                                color: Colors.blue.shade900,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Attendance",
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
                          Text("Standard : " + stdName, style: TextStyle(
                            fontSize: 16
                          ),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex:2,
                            child: IconButton(
                              onPressed: (){

                              } , icon: Icon(Icons.search_rounded)
                            ),
                          ),
                          Expanded(
                            // flex:2,
                            child: IconButton(

                                onPressed: (){

                                } , icon: Icon(Icons.more_vert)
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),10),
            placeASizedBoxHere(20),
            (isFetching)
              ?loadingPage()
              :customPaddedRowWidget(ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.white,
                      width: 100,
                      height: double.parse(height.toString()),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0, left: 28.0),
                        child: Table(
                          border: TableBorder.symmetric(
                              inside: BorderSide(
                                color: Color(0xffdfdfdf),
                                width: 2
                              )
                          ),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(120),
                            1: FixedColumnWidth(15)
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            for(var i=0;i<length;i++)
                              getTableRow(
                                Text(myStudents?.elementAt(i).firstName ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                                IconButton(
                                  onPressed: (flags[i])?() async {
                                    flags[i] = false;
                                    (mounted)?setState(() {

                                    }):null;
                                    toast("Updating data...");

                                    var result = myStudents?.elementAt(i).posted ?? false
                                        ?await removeAttendance(myStudents?.elementAt(i).id ?? "",widget.selectedDate.toString().substring(0,10))
                                        :await addAttendance(myStudents?.elementAt(i).id ?? "",widget.selectedDate.toString().substring(0,10));
                                    
                                    if(result == false){
                                      toast("Error Posting Try Again");
                                    }
                                    else {
                                      flags[i] = true;
                                      var temp = myStudents?.elementAt(i).posted;
                                      myStudents?.elementAt(i).posted = !(temp!);
                                    }
                                    (mounted)?setState(() {

                                    }):null;
                                  } : null

                               , icon: (myStudents?.elementAt(i).posted ?? false)
                                    ?Icon(Icons.check_circle,color: Colors.deepPurple,)
                                    :Icon(Icons.check_circle_outline_sharp,color: Color(0xffdfdfdf),)
                                ), "start", "center")
                          ],
                        ),
                      )
                  ),
                ), 20),
            placeASizedBoxHere(10),
            ElevatedButton(onPressed: () async{
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.setString(widget.selectedDate.toString().substring(0,10), true.toString());
              popPagesNtimes(context, 2);
            }, child: Text("Close Attendance"))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getMyAttendance();
  }
}

class AttendanceSheetFixed extends StatefulWidget {
  const AttendanceSheetFixed({
    Key? key,
    required this.selectedDate
  }) : super(key: key);
  final selectedDate;
  @override
  State<AttendanceSheetFixed> createState() => _AttendanceSheetFixedState();
}

class _AttendanceSheetFixedState extends State<AttendanceSheetFixed> {
  List<StudentModel>? myStudents;
  var length = 0;
  var height = 0;
  var isFetching = true;
  var stdName = "";
  getMyAttendance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stdId = preferences.getString("class-Teacher");
    myStudents = await getAttendance(stdId!, widget.selectedDate);
    (mounted)?setState(() {
      length = myStudents?.length ?? 0;
      height = (length) * 60;
      stdName = myStudents?.elementAt(0).std_name ?? "";
      isFetching = false;
    }):null;
  }

  @override
  void initState() {
    getMyAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: getAppBar(APP_NAME),
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            customPaddedRowWidget(Row(
              children: [
                Expanded(
                  flex:2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 30,
                            color: Colors.blue.shade900,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Attendance",
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
                      Text("Standard : " + stdName, style: TextStyle(
                          fontSize: 16
                      ),)
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: IconButton(
                            onPressed: (){

                            } , icon: Icon(Icons.search_rounded)
                        ),
                      ),
                      Expanded(
                        // flex:2,
                        child: IconButton(

                            onPressed: (){

                            } , icon: Icon(Icons.more_vert)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),10),
            placeASizedBoxHere(20),
            (isFetching)
                ?loadingPage()
                :customPaddedRowWidget(ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: Colors.white,
                  width: 100,
                  height: double.parse(height.toString()),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0, left: 28.0),
                    child: Table(
                      border: TableBorder.symmetric(
                          inside: BorderSide(
                              color: Color(0xffdfdfdf),
                              width: 2
                          )
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(120),
                        1: FixedColumnWidth(15)
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        for(var i=0;i<length;i++)
                          getTableRow(
                              Text(myStudents?.elementAt(i).firstName ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                              (myStudents?.elementAt(i).posted ?? false)
                                  ?Icon(Icons.check_circle,color: Colors.deepPurple,)
                                  :Icon(Icons.check_circle_outline_sharp,color: Color(0xffdfdfdf),)
                              , "start", "center")
                      ],
                    ),
                  )
              ),
            ), 20),
            placeASizedBoxHere(10),
          ],
        ),
      ),
    );
  }
}

