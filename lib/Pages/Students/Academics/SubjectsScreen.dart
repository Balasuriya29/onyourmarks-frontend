import 'package:flutter/material.dart';

import '../../../Models/Student Models/SubjectModel.dart';


class SubjectsScreen extends StatefulWidget {
  final List<SubjectModel>? subjects;
  const SubjectsScreen(this.subjects,{Key? key}) : super(key: key);

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(itemBuilder: (BuildContext context,int index){
          return Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Subject Name : "+(widget.subjects?.elementAt(index).subName.toString() ?? " "),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Total Marks : "+(widget.subjects?.elementAt(index).totalMarks.toString() ?? " "),style: TextStyle(fontSize: 15),),
                  ),
                ],
              ),
            ),
          );
        }, itemCount: widget.subjects?.length ?? 0,
          separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
          );
        },),
      ),
    );
  }
}
