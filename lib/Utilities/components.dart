import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Models/Teacher%20Models/ExamModel.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';

import '../Models/Student Models/CCAModel.dart';
import '../Pages/Students/CCA/CCAForm.dart';
import '../main.dart';

AppBar getAppBar(String name){
  return AppBar(
    title: Text(name),
  );
}

Expanded placeAExpandedHere(int flex){
  return Expanded(flex:flex , child: Text(""),);
}

Expanded getExpanded(int flex, Widget child){
  return Expanded(
      flex: flex,
      child: child
  );
}

SizedBox placeASizedBoxHere(double height){
  return SizedBox(height: height);
}

Row populateCardsWithSubjectDetails(String field,double fieldSize,String? value,double valueSize){
  return Row(
    children: [
      getTheStyledTextForExamsList(field,fieldSize),
      getTheStyledTextForExamsList(value,valueSize),
    ],
  );
}

ListView populateExamsObjectToListView(BuildContext context, List<ExamModel> exams, String type){
  var color = (type == "upcoming")
                ?Colors.blue
                :(type == "in progress")
                  ?Colors.green
                  :Colors.amber;
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ExamDetailsView(exams.elementAt(index),color)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                          child: SizedBox(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:18.0),
                                      child: getTheStyledTextForExamsList(exams.elementAt(index).examName.toString(),20)
                                    ),
                                    SizedBox(
                                      width: 75,
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).std_name.toString(),20)
                                  ],
                                ),
                                placeASizedBoxHere(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: getTheStyledTextForExamsList("From : ", 15),
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).subjects?.first.date?.substring(0,10) ?? ' ', 15),
                                  ],
                                ),
                                placeASizedBoxHere(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: getTheStyledTextForExamsList("To : ", 15),
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).subjects?.last.date?.substring(0,10) ?? ' ', 15)
                                  ],
                                )
                              ],
                            ),
                          ),
                          color: color,
                      ),
                    ),
                  );

                }
                , separatorBuilder: (BuildContext context, int index){
              return SizedBox(
                height: 20,
              );
            }
            , itemCount: exams.length);
}

Text getTheStyledTextForExamsList(String? field, double fontSize){
  return Text(field ?? ' ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),);
}

Center loadingPage(){
  return Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      placeASizedBoxHere(20),
      Text("Loading Data")
    ],
  ));
}

class BuildChoiceChips extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;
  const BuildChoiceChips(this.items,{required this.onSelectionChanged});

  @override
  State<BuildChoiceChips> createState() => _BuildChoiceChipsState();
}

class _BuildChoiceChipsState extends State<BuildChoiceChips> {

  List<String> selectedChoices = [];
  buildChoiceChips(){
    List<Widget> choices = [];
    widget.items.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          selectedColor: Colors.blue,
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
        ),
      ));
    });
    return choices;
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: buildChoiceChips(),
    );
  }
}

Widget populateCCAObjectToListView(BuildContext context, List<CCAModel> activities, String type){
  var color = (type == "pending")
      ?Colors.blue
      :(type == "accepted")
        ?Colors.green
        :Colors.amber;
  
  int len = activities.length-1;
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return (type == "pending" && index == len)
          ?GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    children: [
                      Card(
                        child: SizedBox(
                          height: 175,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 18.0,left: 18.0,right: 18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: getTheStyledTextForCCAList(activities.elementAt(index).name.toString(),20)),
                                    Expanded(
                                        flex: 1,
                                        child: Text("")
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: getTheStyledTextForCCAList(activities.elementAt(index).status.toString(),20))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: getTheStyledTextForCCAList("Type : ", 15),
                                  ),
                                  getTheStyledTextForCCAList(activities.elementAt(index).type ?? ' ', 15),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: getTheStyledTextForCCAList("Status : ", 15),
                                  ),
                                  getTheStyledTextForCCAList(activities.elementAt(index).isVerified ?? ' ', 15)
                                ],
                              ),

                            ],
                          ),
                        ),
                        color: color,
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(17.5)
                        ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCCAForm()));
                      }, child: Icon(CupertinoIcons.add))
                    ],
                  ),
              ),
            )
          :GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0,left: 18.0,right: 18.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).name.toString(),20)),
                              Expanded(
                                  flex: 1,
                                  child: Text("")
                              ),
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).status.toString(),20))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Type : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).type ?? ' ', 15),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Status : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).isVerified ?? ' ', 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: color,
                ),
              ],
            ),
          ),
        );
      }
      , separatorBuilder: (BuildContext context, int index){
    return SizedBox(
      height: 20,
    );
  }
      , itemCount: activities.length);
}

Text getTheStyledTextForCCAList(String? field, double fontSize){
  return Text(field ?? ' ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),);
}

Padding getsideCards(Icon icon, String title2, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              child: icon,
            ),
            Expanded(
              child: ListTile(
              title: Text(title2),
              ),
            ),
          ],
        ),
      ),
    );
}

List<Widget> getImageSlider(List<String> imagesList){
  List<Widget> imageSliders = imagesList
      .map((item) => Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ))
      .toList();
  return imageSliders;
}

SizedBox populateTheEvents(String? title, String? content, String? category){
  return SizedBox(
      width: 200,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 160,
                      minWidth: 400
                    ),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38.0,top: 8.0,right: 38.0,bottom: 38.0),
                          child: ListTile(
                            title: Text(title ?? "",  style: TextStyle(fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                            subtitle: Text(content ?? ""),
                          ),
                        )

                    )
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Icon(
                  CupertinoIcons.bookmark_fill,
                  color: Colors.deepOrange,
                  size: 30,
              ),
            ),
          ],
        ),
      )
  );
}

Padding getBottomDrawerNavigation(context){
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Column(
      children: [
        GestureDetector(
            onTap: (){

            },
            child: getsideCards(Icon(Icons.settings) , 'Settings', context)
        ),
        GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: getsideCards(Icon(Icons.logout) , 'Log Out', context)
        ),
      ],
    ),
  );
}

Row customPaddedRowWidget(Widget mainWidget){
  return Row(
    children: [
      Expanded(child: Text("")),
      Expanded(
        flex: 10,
        child: mainWidget,
      ),
      Expanded(child: Text(""))
    ],
  );
}
