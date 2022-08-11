import 'package:flutter/material.dart';
import '../../../ApiHandler/Student/StudentsAPIs.dart';
import '../../../Models/Student Models/MarksModel.dart';
import '../../../Utilities/Components/functional.dart';
import 'MarksScreen.dart';

class MyMarks extends StatefulWidget {
  const MyMarks({Key? key}) : super(key: key);

  @override
  State<MyMarks> createState() => _MyMarksState();
}

class _MyMarksState extends State<MyMarks> {
  Map<String,List<MarksModel>> map = {};
  List<String> exam_names = [];
  var isFetching = true;
  fetchingMarks() async{
    await getMyMarks().then((value) {
      map = value;
      for(var i in map.keys){
        exam_names.add(i);
      }
      // debugPrint(exam_names.toString());
      setState(() {
        isFetching = false;
      });
    });

  }

  @override
  void initState() {
    fetchingMarks();
  }

  @override
  Widget build(BuildContext context) {
    return (isFetching)
      ?loadingPage()
      :(exam_names.isEmpty)
        ?Center(child: Text("No Results to Show"),)
            :Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.separated(itemBuilder: (BuildContext context,int index){
                        return GestureDetector(
                          child: Card(
                            child: Container(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(exam_names.elementAt(index),style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MarksScreen(map[exam_names.elementAt(index)])));
                          },
                        );
                      }, separatorBuilder: (BuildContext context,int index){
                        return SizedBox(height: 10,);
                      }, itemCount: exam_names.length),
                  ),
                ],
              ),
            );
  }
}