import 'package:flutter/material.dart';

import '../../../Utilities/components.dart';
import '../../../Models/Student Models/MarksModel.dart';


class MarksScreen extends StatefulWidget {
  final List<MarksModel>? marks;
  const MarksScreen(this.marks,{Key? key}) : super(key: key);

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: getAppBar("My Marks"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(itemBuilder: (BuildContext context,int index){
          return Card(
            child: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.marks?.elementAt(index).sub_name.toString() ?? " ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text((widget.marks?.elementAt(index).obtained_marks.toString() ?? " ")+"/"+(widget.marks?.elementAt(index).total_marks.toString() ?? " "),style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
            ),
          );
        }, itemCount: widget.marks?.length ?? 0,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },),
      ),
    );
  }
}
