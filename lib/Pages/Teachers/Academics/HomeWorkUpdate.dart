import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';

class HomeWorkUpdatePage extends StatefulWidget {
  const HomeWorkUpdatePage({Key? key}) : super(key: key);

  @override
  State<HomeWorkUpdatePage> createState() => _HomeWorkUpdatePageState();
}

class _HomeWorkUpdatePageState extends State<HomeWorkUpdatePage> {
  var stdHW = {
    "8" : {
      "Science" : {
        "Test" : "Unit 5 - One Marks",
      },"Tamil" : {
        "Test": "Poem",
      }
    },
    "10" : {
      "Physics" : {
        "Test" : "Unit 2 - Third Part only",
      },"Biology" : {
        "Diagram Homework" : "Draw the diagram of human lungs",
      },"Chemistry" : {
        "Oral Test" : "Salt Analysis Test",
      },"Maths" : {
        "Class Work Submission" : "Complete all the Exercises Problems",
      },
    }
  };
  var stdsValues, stds;

  var colorsOfCard = List.filled(12, Colors.white);

  var dateController = DateRangePickerController();
  var flag = false;
  var std = "";
  var flag2 = true;
  var readOnlyOutSide = [];
  getHomeWork(std){
    stds = stdHW.keys.toList();
    stdsValues = stdHW.values.toList();
    var titles = [];
    var descriptions = [];
    var subjects = [];
    if(stds.contains(std)){
      var index = stds.indexOf(std);
      var temp = stdsValues[index];
      subjects = temp.keys.toList();
      for(var i in temp.values.toList()){
        titles.add(i.keys.toList().first);
        descriptions.add(i.values.toList().first);
      }
    }
    titles.add("last");
    descriptions.add("last");
    subjects.add("last");
    var textTitleController = [];
    var textSubjectController = [];
    var textDescController = [];
    var readOnlys;
    if(flag2){
      readOnlys = List.filled(subjects.length, true);
      readOnlyOutSide = List.filled(subjects.length, true);
      flag2 = false;
    }
    else{
      readOnlys = readOnlyOutSide;
    }
    // print("Starting:"+readOnlys.toString());
    for(int i = 0;i<subjects.length;i++){
      textSubjectController.add(TextEditingController(text:subjects[i]));
      textTitleController.add(TextEditingController(text:titles[i]));
      textDescController.add(TextEditingController(text:"\t\t\t\t\t\t\t\t\t\t"+descriptions[i]));
    }
    textSubjectController.add(TextEditingController());
    textTitleController.add(TextEditingController());
    textDescController.add(TextEditingController());

    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index){
        return  (subjects.elementAt(index) != "last")
          ?customPaddedRowWidget(Center(
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
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black26,
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
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
                Positioned(
                  top: 10,
                  left: 290,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5)
                      ),
                      onPressed: (){
                        stdHW[std]?.remove(subjects.elementAt(index));
                        // print(stdHW.toString());
                        (mounted)?setState(() {

                        }):null;
                      }, child: Icon(CupertinoIcons.delete,size: 17.5,)),
                ),
                Positioned(
                  top: 10,
                  left: 240,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade700,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5)
                    ),
                    onPressed: (){
                      readOnlyOutSide[index] = !readOnlyOutSide[index];

                      // print(stdHW[std]![textSubjectController[index].text]);
                      if(readOnlyOutSide[index]){
                        stdHW[std]![textSubjectController[index].text]!.clear();
                        // print(stdHW);
                        stdHW[std]![textSubjectController[index].text]![textTitleController[index].text] = textDescController[index].text.toString().trim();
                        // print(stdHW);
                      }
                      (mounted)?setState(() {

                      }):null;
                      // print(readOnlys.toString());
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCCAForm()));
                    }, child: (readOnlyOutSide[index])?Icon(Icons.edit,size: 17.5,):Icon(Icons.check_circle,size: 17.5,)
                  ),
                ),
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
                              var temp = stdHW[std];
                              if(temp!=null) {
                                stdHW[std]?.putIfAbsent(
                                    textSubjectController.last.text, () =>
                                {
                                  textSubjectController.last.text: textSubjectController.last.text
                                });
                              }
                              else{
                                stdHW.putIfAbsent(
                                    std , () =>
                                {
                                  textSubjectController.last.text
                                      :{
                                    textSubjectController.last.text: textSubjectController.last.text
                                  }
                                }
                                );
                              }
                              (mounted)?setState(() {

                              }):null;
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
      }, itemCount: subjects.length);
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
                        std = (index+1).toString();
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
                            color: colorsOfCard.elementAt(index),
                            height: 20,
                            width: 50,
                            child: Center(child: Text((index+1).toString(), style: TextStyle(
                                fontSize: 15
                            ),)),
                          ),
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index){
                return SizedBox(
                  width: 20,
                );
              }, itemCount: 12), 20),
            ),
            Expanded(
              child: (std != "")
              ?(dateController.selectedDate == null)
                  ?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select A Date")
                      ],
                    )
                  :getHomeWork(std)
              :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Select A Standard")
                ],
              )
              ,
            ),
          ],
        ),
    );
  }
}

