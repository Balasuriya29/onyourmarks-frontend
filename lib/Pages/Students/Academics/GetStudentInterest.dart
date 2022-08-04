import 'package:flutter/material.dart';

import '../../../Utilities/components.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Give Your Interests!!!"),
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
                onPressed: (){
              debugPrint(selectedReportList.toString());
            }, child: Text("Show Interest")),
          )
        ],
      ),
    );
  }
}
