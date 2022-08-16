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
    return Column(
      children: [
        placeASizedBoxHere(50),
        getHeader("Results", "HERE'S YOUR MARKS"),
        placeASizedBoxHere(20),
        (isFetching)
          ?loadingPage()
          :(exam_names.isEmpty)
            ?Center(child: Text("No Results to Show"),)
            :customPaddedRowWidget(ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exam_names.elementAt(index),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          placeASizedBoxHere(10),
                          Text(
                            "From : " +
                            map.values.toList().first.first.date.toString().substring(0,10),

                          ),
                          Text(
                              "To      : " +
                              map.values.toList().first.last.date.toString().substring(0,10)
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MarksScreen(map[exam_names.elementAt(index)])));
            },
          );
        }, separatorBuilder: (BuildContext context,int index){
          return SizedBox(height: 10,);
        }, itemCount: exam_names.length), 10)
      ],
    );
  }
}