import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Models/Teacher%20Models/ExamModel.dart';
import 'package:onyourmarks/staticNames.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/components.dart';
import '../../Models/Teacher Models/StudentModel.dart';

class ExamViewPage extends StatefulWidget{
  const ExamViewPage({Key? key}) : super(key: key);

  @override
  State<ExamViewPage> createState() => _ExamViewPageState();
}

class _ExamViewPageState extends State<ExamViewPage> with TickerProviderStateMixin{
  late TabController _tabController = TabController(length: 3, vsync: this);
  List<ExamModel> exams = [];
  List<ExamModel> upcoming = [];
  List<ExamModel> inProgress = [];
  List<ExamModel> finished = [];
  bool isFetching = true;
  getExamsFunc() async {
    exams = await getExams();
    for(var i in exams){
      (i.status == 'upcoming')
          ?upcoming.add(i)
          :(i.status == 'in progress')
              ?inProgress.add(i)
              :finished.add(i);
    }

    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    getExamsFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Exams"),
      body: (isFetching)
              ?loadingPage()
              :Column(
                children: [
                  DefaultTabController(
                    length: 3,
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.deepPurple,
                        labelColor: Colors.deepPurple,

                        tabs: const [
                          Tab(
                            text: "Upcoming",
                          ),
                          Tab(
                            text: "In Progress",
                          ),
                          Tab(
                            text: "Finished",
                          )
                        ]),

                  ),
                  Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          (upcoming.isNotEmpty)
                            ?populateExamsObjectToListView(context,upcoming, "upcoming")
                            :Center(
                              child: Text("No Exams Scheduled📅")
                             ),
                          (inProgress.isNotEmpty)
                              ?populateExamsObjectToListView(context,inProgress, "in progress")
                              :Center(
                              child: Text("No Exams is in the Progress📝")
                          ),
                          (finished.isNotEmpty)
                              ?populateExamsObjectToListView(context,finished, "finished")
                              :Center(
                              child: Text("No Exams in the Past🔁🕧")
                          ),
                        ]
                    ),
                  )
                ],
      ),
    );
  }
}

class ExamDetailsView extends StatefulWidget {
  final ExamModel exam;
  final Color color;
  const ExamDetailsView(this.exam,this.color,{Key? key}) : super(key: key);

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0,top: 30.0,right: 30.0,bottom: 15.0),
            child: Text(
                widget.exam.examName.toString()+" - "+widget.exam.std_name.toString(),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,

            ),),
          ),
          Expanded(
            child: ListView.separated(itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0,top: 18.0,right: 18.0),
                  child: Card(
                    color: widget.color,
                    child: Container(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  populateCardsWithSubjectDetails("Name : ", 15, widget.exam.subjects?.elementAt(index).subName ?? ' ', 15),
                                  placeASizedBoxHere(10),
                                  populateCardsWithSubjectDetails("Total Marks : ", 15, widget.exam.subjects?.elementAt(index).totalMarks ?? ' ', 15),
                                  placeASizedBoxHere(10),
                                  populateCardsWithSubjectDetails("Date : ", 15, widget.exam.subjects?.elementAt(index).date?.substring(0,10) ?? ' ', 15)
                                ],
                              ),
                            ),
                            placeAExpandedHere(1),
                            Expanded(
                              flex: 1,
                              child: (widget.exam.status != 'upcoming')
                                        ?Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentsToUpdateMarks(widget.exam.exam_id, widget.exam.std_id, widget.exam.subjects?.elementAt(index).id, widget.exam.std_name, widget.exam.subjects?.elementAt(index).totalMarks)));
                                  }, icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                    )
                                  )
                                ],
                              )
                                        :Text(""),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index){
              return SizedBox(
                height: 0,
              );
            }, itemCount: widget.exam.subjects?.length ?? 0),
          ),
        ],
      ),
    );
  }
}

class ShowStudentsToUpdateMarks extends StatefulWidget {
  final exam_id;
  final subject_id;
  final std_id;
  final std_name;
  final total_marks;
  const ShowStudentsToUpdateMarks(this.exam_id,this.std_id,this.subject_id,this.std_name,this.total_marks,{Key? key}) : super(key: key);
  
  @override
  State<ShowStudentsToUpdateMarks> createState() => _ShowStudentsToUpdateMarksState();
}

class _ShowStudentsToUpdateMarksState extends State<ShowStudentsToUpdateMarks> {
  List<StudentModel> students = [];
  bool isFetching = true;
  List<TextEditingController> _markController = [];
  List<bool> flags = [];
  bool isPending = true;
  bool isAuthoried = false;
  bool mix = false;
  String id = "";
  var pending,total;

  getTeacherId(String id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id")!;
    });
  }

  getStudentsFunc(String id) async{
    await getStudentsOfGivenSTD(id)
    .then((value) async {
        students = value;
        pending = total = students.length;
        isFetching = false;
        var res = await http.get(
            Uri.parse(API_LINK+"api/teacher/studentsmarks/"+widget.exam_id+"/"+widget.subject_id),
            headers:{
              "content-type":"application/json",
              "x-auth-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmRkM2NkM2MwYjM3MDIyN2Q4YTFjZjEiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMTgwMn0.ZrTJeijKPLjiQkNLVLlyyEAj4YuDv4h0_ucsyCcDVQ0"
            },
        );
        var marks = json.decode(res.body);
        if(marks.toString() == '[]') {
          for (var i in students) {
            _markController.add(TextEditingController(text: 0.toString()));
            flags.add(false);
          }
        }
        else {
          var studentsIds = [];
          var obtainedMarks = [];
          for (var i in marks) {
            studentsIds.add(i["student_id"]);
            obtainedMarks.add(i["obtained"]);
          }

          for (var i in students) {
            var check = studentsIds.contains(i.id);
            var obtained = check
                ? obtainedMarks[studentsIds.indexOf(i.id)]
                : 0;
            if(obtained != 0) pending--;
            _markController.add(
                TextEditingController(text: obtained.toString()));
            flags.add((check) ? true : false);
          }

          if(students.length == studentsIds.length) 
            isPending = false;
          else
            isPending = true;
        }

        setState(() {
          mix = isPending && isAuthoried;
        });
    });
  }

  hasAuthority() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var subjects = json.decode(preferences.getString("teacherSubjects") ?? "");
    if(subjects.contains(widget.subject_id)){
      setState(() {
        isAuthoried = true;
      });
    }
  }

  @override
  void initState() {
    getStudentsFunc(widget.std_id);
    hasAuthority();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0,top: 30.0,right: 30.0,bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student Models Marks of Standard "+widget.std_name,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                (mix)
                    ?Text(
                      "Pending: "+pending.toString()+" / "+total.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    :Text(""),
              ],
            ),
          ),
          (isFetching)
          ?loadingPage()
          :Expanded(
            child: ListView.separated(itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0,top: 18.0,right: 18.0),
                  child: Card(
                    color: Colors.deepPurple,
                    child: Container(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  populateCardsWithSubjectDetails("Name : ", 15, students.elementAt(index).firstName, 15),
                                  placeASizedBoxHere(20),
                                  populateCardsWithSubjectDetails("Roll No : ", 15, students.elementAt(index).rollNo, 15),
                                  placeASizedBoxHere(20),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 70,
                                          child: (isAuthoried)
                                            ?TextField(
                                            enabled: !flags.elementAt(index),
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)
                                              ),
                                                focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white)
                                                ),
                                              contentPadding: EdgeInsets.all(2),
                                              isDense: true
                                            ),
                                            controller: _markController.elementAt(index),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,3}$')),
                                            ],
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          )
                                            :Text("Mark: "+_markController.elementAt(index).text,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),)
                                      ),
                                      populateCardsWithSubjectDetails("/ ", 15, widget.total_marks, 15)
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            placeAExpandedHere(1),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                  (isAuthoried)
                                    ?IconButton(
                                    onPressed: () async {
                                      if(!flags[index]) {
                                            postStudentMarks(students.elementAt(index).id.toString(),
                                            widget.exam_id,
                                            widget.subject_id,
                                            int.parse(_markController.elementAt(index).text));
                                      }
                                          setState(() {
                                          flags[index] = !flags[index];
                                          pending--;
                                        });
                                    },
                                    icon: (flags.elementAt(index))
                                          ?Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 35
                                          )
                                          :Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.white,
                                            size: 35
                                          ),

                                  ):Text(""),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index){
              return SizedBox(
                height: 0,
              );
            }, itemCount: students.length),
          ),
        ],
      ),
    );
  }
}
