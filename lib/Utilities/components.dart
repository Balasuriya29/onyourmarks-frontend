import 'package:flutter/material.dart';
import 'package:onyourmarks/Models/Teacher%20Models/ExamModel.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Student Models/CCAModel.dart';

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

ListView populateCCAObjectToListView(BuildContext context, List<CCAModel> activities, String type){
  var color = (type == "pending")
      ?Colors.blue
      :(type == "accepted")
      ?Colors.green
      :Colors.amber;
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          // onTap: (){
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ExamDetailsView(exams.elementAt(index),color)));
          // },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: SizedBox(
                height: 150,
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
      , itemCount: activities.length);
}

Text getTheStyledTextForCCAList(String? field, double fontSize){
  return Text(field ?? ' ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),);
}


