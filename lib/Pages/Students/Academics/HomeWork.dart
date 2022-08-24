import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/homeworkAPIs.dart';
import 'package:onyourmarks/Models/HomeWorkModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';

class HomeWorkPage extends StatefulWidget {
  const HomeWorkPage({Key? key}) : super(key: key);

  @override
  State<HomeWorkPage> createState() => _HomeWorkPageState();
}

class _HomeWorkPageState extends State<HomeWorkPage> {
  var subjects = [];
  var titles = [];
  var descriptions = [];
  var teachers = [];
  var dates = [];
  var map = {};

  var dateController = DateRangePickerController();
  var flag = false;
  var isFetching = true;
  var isSetting = true;
  List<HomeWorkModel>? hws;

  getHomeworks() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var std = jsonDecode(preferences.getString("student-personalDetails").toString())["std_id"]["_id"];
    hws = await getMyHomeWorks(std);
    for(var i in hws!){
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
    (mounted)?setState((){}):null;
  }

  getSelectedDateHomeWorks(String date){
    titles.clear();
    descriptions.clear();
    teachers.clear();
    dates.clear();
    subjects.clear();
    var objects = map[date];
    if(objects != null) {
      for (var i in objects) {
        var space = i.subject?.indexOf(" ");
        (space == -1) ? subjects.add(i.subject) : subjects.add(
            i.subject?.substring(0, space));
        titles.add(i.title);
        descriptions.add(i.description);
        teachers.add(i.teacher_name);
        dates.add(DateTime.parse(i.date ?? ""));
      }
    }
    
    isSetting = false;
    (mounted)?setState((){}):null;
  }

  @override
  void initState() {
    getHomeworks();
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
                        Text(
                          "Tasks",
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
                    Text("Love to study".toUpperCase())
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  color: Colors.deepPurple,
                  elevation: 10,
                  child: TextButton(
                    onPressed: (){
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title:Container(
                          width: 500,
                          height: 400,
                          child: Builder(
                            builder: (context) {
                              return SfDateRangePicker(
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
                                  getSelectedDateHomeWorks(dateController.selectedDate.toString().substring(0,10));
                                  Navigator.pop(context);
                                  (mounted)?setState(() {
                                    flag = true;

                                  }):null;

                                },
                                monthCellStyle: const DateRangePickerMonthCellStyle(
                                    blackoutDateTextStyle: TextStyle(
                                        color: Colors.red, decoration: TextDecoration.lineThrough)),
                                monthViewSettings: DateRangePickerMonthViewSettings(
                                  showTrailingAndLeadingDates: true,),
                                selectableDayPredicate: selectableDayPredicateDatesForHW,

                              );
                            }
                          ),
                        ),
                      );
                    });
                  }, child: (flag)
                      ?Text(dateController.selectedDate.toString().substring(0,10), style: TextStyle(color: Colors.white),)
                      :Text("Select A Date",style: TextStyle(color: Colors.white)), ),
                ),
              )
            ],
          ),10),
          placeASizedBoxHere(30),
          (isFetching)
            ?loadingPage()
            :(dateController.selectedDate != null)
              ?(isSetting)
                ?loadingPage()
                :(subjects.isEmpty)
                  ?Text("No Tasks Assigned")
                  :Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        return customPaddedRowWidget(
                          Center(
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
                                                  child: Text(
                                                    titles.elementAt(index),
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(
                                                        fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  thickness: 1,
                                                  color: Colors.black26,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 28.0),
                                                  child: Text(
                                                    descriptions.elementAt(index),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(fontSize: 15, color: Colors.grey),
                                                  ),
                                                ),
                                                placeASizedBoxHere(70),
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
                                        child: Text(
                                          subjects.elementAt(index),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), 30);
                      },
                      separatorBuilder: (BuildContext context, int index){
                        return placeASizedBoxHere(10);
                      }, itemCount: subjects.length),
                  )
              :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please Select A Date")
                ],
          ),
        ],
      ),
    );
  }
}

