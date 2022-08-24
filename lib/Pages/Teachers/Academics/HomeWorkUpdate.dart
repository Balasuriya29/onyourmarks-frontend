import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/homeworkAPIs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Models/HomeWorkModel.dart';
import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';
import '../TeacherHome.dart';

class HomeWorkUpdatePage extends StatefulWidget {
  const HomeWorkUpdatePage({Key? key}) : super(key: key);

  @override
  State<HomeWorkUpdatePage> createState() => _HomeWorkUpdatePageState();
}

class _HomeWorkUpdatePageState extends State<HomeWorkUpdatePage> {
  // var stdHW = {
  //   "12-A" : {
  //     "Science" : {
  //       "Test" : "Unit 5 - One Marks",
  //     },"Tamil" : {
  //       "Test": "Poem",
  //     }
  //   },
  //   "12-B" : {
  //     "Physics" : {
  //       "Test" : "Unit 2 - Third Part only",
  //     },"Biology" : {
  //       "Diagram Homework" : "Draw the diagram of human lungs",
  //     },"Chemistry" : {
  //       "Oral Test" : "Salt Analysis Test",
  //     },"Maths" : {
  //       "Class Work Submission" : "Complete all the Exercises Problems",
  //     },
  //   }
  // };
  var map = {};
  var stdHW = {};

  var stdsValues, stds;

  var colorsOfCard = List.filled(12, Colors.white);

  var colorOfIndex;

  var dateController = DateRangePickerController();
  var flag = false;
  var std = "";
  var flag2 = true;
  var readOnlyOutSide = [];
  var standardOrg = [];
  var standardIdsOrg = [];
  var isFetching = true;
  var isSetting = true;
  var isloading = false;

  getHomeWork(std, date){
    getMapOfHWObjectsWithStandard(date);
    stds = stdHW.keys.toList();
    stdsValues = stdHW.values.toList();
    var titles = [];
    var descriptions = [];
    var subjects = [];
    var textTitleController = [];
    var textSubjectController = [];
    var textDescController = [];
    var teachers = [];
    var dates = [];
    if(stds.contains(std)){
      var index = stds.indexOf(std);
      var temp = stdsValues[index];
      // print("sdklnsdkon"+temp.toString());
      // subjects = temp.keys.toList();
      for(var i in temp){
        titles.add(i.title);
        descriptions.add(i.description);
        var space = i.subject?.indexOf(" ");
        (space == -1) ? subjects.add(i.subject) : subjects.add(
            i.subject?.substring(0, space));
        teachers.add(i.teacher_name);
        dates.add(DateTime.parse(i.date ?? ""));
      }
    }
    var readOnlys = [];
    // print("Method"+readOnlys.toString());
    // print("Method Subjects"+subjects.toString());
    // print(flag2.toString());
    if(flag2){
      for(var i=0;i<subjects.length;i++){
        readOnlys.add(true);
        readOnlyOutSide.add(true);
      }
      flag2 = false;
      setState((){});
      // print("dsjkdsndsk"+readOnlys.toString());
    }
    else{
      readOnlys = readOnlyOutSide;
    }
    // print("Method"+flag2.toString());
    // print(readOnlys.toString());
    // print(stdHW.toString());
    // print("Starting:"+readOnlys.toString());
    for(int i = 0;i<subjects.length;i++){
      textSubjectController.add(TextEditingController(text:subjects[i]));
      textTitleController.add(TextEditingController(text:titles[i]));
      textDescController.add(TextEditingController(text:"\t\t\t\t\t\t\t\t\t\t"+descriptions[i]));
    }
    if(isToday()) {
      titles.add("last");
      descriptions.add("last");
      subjects.add("last");
      textSubjectController.add(TextEditingController());
      textTitleController.add(TextEditingController());
      textDescController.add(TextEditingController());
    }

    return
      (subjects.isNotEmpty)
        ?Expanded(
          child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            return (subjects.elementAt(index) != "last")
              ?customPaddedRowWidget(Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ColoredBox(
                          color: Color(0xffE6F3F7),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28.0),
                                      child: TextField(
                                        controller: textTitleController.elementAt(index),
                                        textAlign: TextAlign.start,
                                        readOnly: readOnlys.elementAt(index),
                                        autofocus: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Title",
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black26,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28.0),
                                      child:TextField(
                                        controller: textDescController.elementAt(index),
                                        readOnly: readOnlys.elementAt(index),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontSize: 15, color: Colors.grey),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Descriptions",
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 15
                                            )
                                        ),
                                        maxLines: null,
                                        minLines: 1,
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                    placeASizedBoxHere(50),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 28.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  "Last Updated by: "),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(teachers.elementAt(index) + " ", style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text(dates.elementAt(index).hour.toString() + ":" + dates.elementAt(index).minute.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    placeASizedBoxHere(30)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 40,
                          color: Color(0xff311B92),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 40,
                          color: Color(0xff418DA3),
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              child: TextField(
                                controller: textSubjectController.elementAt(index),
                                readOnly: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 16, color: Colors.white),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Subject",
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (isToday())?Positioned(
                      top: 10,
                      left: 290,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade700,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5)
                        ),
                        onPressed: (){
                          readOnlyOutSide[index] = !readOnlyOutSide[index];
                          // print("Button"+readOnlyOutSide.toString());
                          // print("Button"+flag2.toString());

                          // print(stdHW[std]![textSubjectController[index].text]);
                          if(readOnlyOutSide[index]){
                            // print(stdHW.toString());
                            stdHW[std][index].title = textTitleController[index].text;
                            stdHW[std][index].description = textDescController[index].text.toString().trim();
                            postHomeWork(
                                textSubjectController[index].text.toString().trim(),
                                textTitleController[index].text.toString().trim(),
                                textDescController[index].text.toString().trim(),
                                standardIdsOrg[standardOrg.indexOf(std)],
                                dateController.selectedDate ?? DateTime.now()
                            );
                          }
                          (mounted)?setState(() {
                            readOnlys = readOnlyOutSide;
                          }):null;
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCCAForm()));
                        }, child: (readOnlyOutSide[index])?Icon(Icons.edit,size: 17.5,):Icon(Icons.check_circle,size: 17.5,)
                      ),
                    ):Text(""),
                  ],
                ),
              ), 30)
              :Column(
                  children: [
                    placeASizedBoxHere(20),
                    Text("Add New Task"),
                    customPaddedRowWidget(Center(
                      child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Color(0xffE6F3F7),
                              height: 200,
                              width: 600,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: TextField(
                                      controller: textTitleController.last,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                      decoration: InputDecoration(
                                          hintText: "Title",
                                          hintStyle: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold
                                          ),
                                        isDense:false,
                                        contentPadding: EdgeInsets.only(top: 20)
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: TextField(
                                      controller: textDescController.last,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15
                                      ),
                                      decoration: InputDecoration(
                                          isDense : false,
                                          contentPadding: EdgeInsets.only(top: 20),
                                          hintText: "Descriptions",
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 15
                                          )
                                      ),
                                      maxLines: null,
                                      minLines: 1,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          top: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 40,
                              color: Color(0xff311B92),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 40,
                              color: Color(0xff418DA3),
                              child: Center(
                                child: SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: textSubjectController.last,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Subject",
                                        hintStyle: TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 290,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5)
                              ),
                              onPressed: (){
                                if(textSubjectController.last.text == ""){
                                  toast("Enter Subject");
                                }
                                else if(textSubjectController.last.text == ""){
                                  toast("Enter Title");
                                }
                                else{
                                  var sub = textSubjectController.last.text.substring(0,1).toUpperCase() + textSubjectController.last.text.substring(1).toLowerCase();
                                  if(subjects.contains(sub)){
                                    toast("Already Assigned");
                                  }
                                  else{
                                    postHomeWork(
                                        textSubjectController.last.text.toString().trim(),
                                        textTitleController.last.text.toString().trim(),
                                        textDescController.last.text.toString().trim(),
                                        standardIdsOrg[standardOrg.indexOf(std)],
                                        dateController.selectedDate ?? DateTime.now()
                                    );
                                    toast("Updated! Reloading...");
                                    isloading = true;
                                    // print("object")
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherHome(3)))
                                    initState();

                                    // var temp = stdHW[std];
                                    // if(temp!=null) {
                                    //   stdHW[std]?.putIfAbsent(
                                    //       textSubjectController.last.text, () =>
                                    //   {
                                    //     textSubjectController.last.text: textSubjectController.last.text
                                    //   });
                                    // }
                                    // else{
                                    //   stdHW.putIfAbsent(
                                    //       std , () =>
                                    //   {
                                    //     textSubjectController.last.text
                                    //         :{
                                    //       textSubjectController.last.text: textSubjectController.last.text
                                    //     }
                                    //   }
                                    //   );
                                    // }
                                    // (mounted)?setState(() {
                                    //
                                    // }):null;
                                  }
                                }
                              }, child: Icon(CupertinoIcons.check_mark,size: 17.5,)),
                        ),
                      ],
              ),
                      ), 30),
                    ],
                  );
      },
      separatorBuilder: (BuildContext context, int index){
          return placeASizedBoxHere(10);
      }, itemCount: subjects.length),
        )
        :ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Tasks Assigned"),
              ],
            );
      }, separatorBuilder: (BuildContext context, int index){
            return placeASizedBoxHere(0);
      }, itemCount: 1);
  }

  bool isToday() => dateController.selectedDate.toString().substring(0,10) == DateTime.now().toString().substring(0,10);

  Future<bool> getStandard() async{
    var standard = [];
    var standardIds = [];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var standardObjects = jsonDecode(preferences.getString("teacherStandardObjects").toString());
    for(var i in standardObjects){
      standard.add(jsonDecode(i)["std_name"]);
      standardIds.add(jsonDecode(i)["_id"]);
    }
    setState(() {
      standardOrg = standard;
      standardIdsOrg = standardIds;
    });
    return true;
  }

  Future<bool> setMapOfHomeWorkObjects(List<HomeWorkModel> hws) async{
    map.clear();
    for(var i in hws){
      var values = map[i.date?.substring(0,10)];
      if(values == null){
        map[i.date?.substring(0,10)] = [i];
      }
      else{
        values.add(i);
        map[i.date?.substring(0,10)] = values;
      }
    }
    isFetching = false;
    // print(map.toString());
    (mounted)?setState((){}):null;
    return true;
  }

  getMapOfHWObjectsWithStandard(String date) {
    // flag2 = true;
    stdHW.clear();
    var values = map[date];
    if(!(values == null)){
      for(var i in values){
        var standard = i.std_name;
        var values = stdHW[standard];
        if(values == null){
          stdHW[standard] = [i];
        }
        else{
          values.add(i);
          stdHW[standard] = values;
        }
        // print("iduihsdfiubsdi "+stdHW.toString());
      }
    }

    (mounted)?setState(() {

    }):null;
  }

  @override
  void initState() {
    getStandard().then((v) async{
      if(v){
        setMapOfHomeWorkObjects(await getAllHomeWorks());
      }
    }).then((value) => {
      setState((){
        isloading = false;
        // flag2 = true;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return Scaffold(
      body: (isLandScape)
        ?Center(
      child: Text("Please Rotate your Device"),
    )
        :Column(
          children: [
            placeASizedBoxHere(50),
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
                          AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                            TypewriterAnimatedText(
                              "Tasks",
                              textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                              speed: Duration(milliseconds: 150),
                              curve: Curves.linear
                          )
                        ]
                      )
                    ],
                  ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Love to study".toUpperCase())
                    ],
                  ),
                ),
                Expanded(
                  flex: (dateController.selectedDate!=null)?3:2,
                  child: Card(
                    color: Colors.deepPurple,
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white,),
                        TextButton(
                          onPressed: (){
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                title:Container(
                                  width: 500,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    showActionButtons: true,
                                    controller: dateController,
                                    onCancel: (){
                                      Navigator.pop(context);
                                    },
                                    onSubmit: (v){
                                      if(dateController.selectedDate == null){
                                        toast("Please Select A Date!");
                                        return;
                                      }
                                      flag2 = true;
                                      (mounted)?setState(() {
                                        flag = true;
                                      }):null;
                                      Navigator.pop(context);
                                    },
                                    monthCellStyle: const DateRangePickerMonthCellStyle(
                                        blackoutDateTextStyle: TextStyle(
                                            color: Colors.red, decoration: TextDecoration.lineThrough)),
                                    monthViewSettings: DateRangePickerMonthViewSettings(
                                      showTrailingAndLeadingDates: true,),
                                    selectableDayPredicate: selectableDayPredicateDatesForHW,

                                  ),
                                ),
                              );
                            });
                          }, child: (flag)
                            ?Text(dateController.selectedDate.toString().substring(0,10), style: TextStyle(color: Colors.white),)
                            :Text("Select \n Date",style: TextStyle(color: Colors.white)), ),
                      ],
                    ),
                  ),
                )
              ],
            ),10),
            placeASizedBoxHere(30),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              color: Colors.blueGrey.shade50,
              child: customPaddedRowWidget(ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        std = standardOrg.elementAt(index);
                        colorOfIndex = index;
                        flag2 = true;
                        // print(std);
                        // print(stdHW);
                        (mounted)?setState(() {

                        }):null;
                        // colorsOfCard[index] = Colors.red;
                        // setState(() {
                        //
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 5,
                          child: Container(
                            color: ((colorOfIndex ?? -1) == index)?Colors.deepPurple:Colors.white,
                            height: 20,
                            width: 50,
                            child: Center(child: Text(standardOrg.elementAt(index), style: TextStyle(
                                fontSize: 15,
                                color: ((colorOfIndex ?? -1) == index)?Colors.white:Colors.black,
                            ),)),
                          ),
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index){
                return SizedBox(
                  width: 20,
                );
              }, itemCount: standardOrg.length), 20),
            ),
            (isloading)
              ?loadingPage()
              :(dateController.selectedDate != null)
                  ?(std != "")
                  ?getHomeWork(std, dateController.selectedDate.toString().substring(0,10))
                  :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Select A Standard")
                ],
              )
                  :Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Select A Date")
              ],
              ),
          ],
        ),
    );
  }
}

