import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Student/StudentsAPIs.dart';
import 'package:onyourmarks/Pages/Students/StudentHome.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';

import '../../../Utilities/Components/class.dart';
import '../../../Utilities/Components/functional.dart';

class GetStudentInterest extends StatefulWidget {
  const GetStudentInterest({Key? key}) : super(key: key);

  @override
  State<GetStudentInterest> createState() => _GetStudentInterestState();
}

class _GetStudentInterestState extends State<GetStudentInterest> {
  List<String> selectedReportList = List.empty();
  List<String> topics = ["English","Maths","Science","Social Sciences","Computer Science","Arts","History","Literature","Philosophy",
    "Visual Arts","Economics","Geography","Political Science","Psychology","Chemistry","Earth Sciences","Life Sciences",
    "Mathematics","Logic","Statistics","Engineering","Law","Architecture and Design"];

  @override
  void initState() {
    topics.shuffle();
    toast("Password Changed, Use Your New Password!!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: double.infinity,),
          BuildChoiceChips(topics, onSelectionChanged: (selectedList) {
            setState(() {
              selectedReportList = selectedList;
            });
          },),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ElevatedButton(
                onPressed: () async {
                  List<int> selectedCount = List.filled(selectedReportList.length, 0);
                  debugPrint(selectedReportList.toString());
                  debugPrint(selectedCount.toString());
                  // print("Before Posted");
                  var posted = await postInterests(selectedReportList, selectedCount,'post');
                  // print("After Posted"+ posted.toString());
                  if(posted){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomeM()));
                  }
                  else{
                    toast("Error Occurred, Please Select this Again");
                    new Future.delayed(Duration(seconds: 5), () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStudentInterest()));
                    });
                  }
            }, child: Text("Show Interest")),
          )
        ],
      ),
    );
  }
}
