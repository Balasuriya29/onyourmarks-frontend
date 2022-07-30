import 'package:flutter/material.dart';
import 'package:onyourmarks/Models/ExamModel.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';

AppBar getAppBar(String name){
  return AppBar(
    title: Text(name),
  );
}

Expanded placeAExpandedHere(int flex){
  return Expanded(flex:flex , child: Text(""),);
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

