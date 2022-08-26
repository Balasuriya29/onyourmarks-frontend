import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utilities/Components/functional.dart';

class LearningOutcomeEvaluation extends StatefulWidget {
  const LearningOutcomeEvaluation({Key? key}) : super(key: key);

  @override
  State<LearningOutcomeEvaluation> createState() => _LearningOutcomeEvaluationState();
}

class _LearningOutcomeEvaluationState extends State<LearningOutcomeEvaluation> {
  var standardOrg = [];
  var standardIdsOrg = [];

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
    print(standardOrg.toString());
    print(standardIds.toString());

    return true;
  }

  var colorOfIndex;
  var std = "";
  var flag2 = true;


  @override
  void initState() {
    getStandard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          placeASizedBoxHere(50),
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
                          color: Colors.deepOrange,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Learning Outcomes",
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
                    Text("Evaluate the Students".toUpperCase(), style: TextStyle(
                        fontSize: 14
                    ),)
                  ],
                ),
              ),
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
                      (mounted)?setState(() {

                      }):null;
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
          placeASizedBoxHere(50),
          customPaddedRowWidget(ListView.separated(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: (){
                  
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, top: 28.0),
                          child: Text("Examination Name", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.5
                          ),),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
                            child: Text(
                              "Time Period"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index){
            return placeASizedBoxHere(30);
          }, itemCount: 2), 7)
        ],
      ),
    );
  }
}

class LearningOutcomesEvalution2 extends StatefulWidget {
  const LearningOutcomesEvalution2({Key? key}) : super(key: key);

  @override
  State<LearningOutcomesEvalution2> createState() => _LearningOutcomesEvalution2State();
}

class _LearningOutcomesEvalution2State extends State<LearningOutcomesEvalution2> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

