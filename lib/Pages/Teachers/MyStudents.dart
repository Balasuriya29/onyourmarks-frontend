import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';

import '../../Utilities/Components/functional.dart';

class MyStudents extends StatefulWidget {
  const MyStudents({Key? key}) : super(key: key);

  @override
  State<MyStudents> createState() => _MyStudentsState();
}

class _MyStudentsState extends State<MyStudents> {
  List<Map<String,dynamic>>? students;
  var isFetching = true;
  var isSearchButtonClicked = false;
  var studentsToShow;
  getStudents() async {
    students = await getMyAllStudents();
    studentsToShow = students;
    (mounted)?setState(() {
      isFetching = false;
    }):null;
    // print(students);
  }

  @override
  void initState() {
    getStudents();
  }

  changeList(String s){
    var newStudents = [];
    for(var i in students!){
      var name = i["first_name"] + " " +i["last_name"];
      if(name.toLowerCase().contains(s.toLowerCase()) ?? false){
        newStudents.add(i);
        print(i.toString());
      }
    }
    studentsToShow = newStudents;
    print(studentsToShow);
    (mounted)?setState(() {

    }):null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          "Students",
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
                    Text("CLASS THAT YOU TEACH", style: TextStyle(
                        fontSize: 14
                    ),)
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: IconButton(
                          onPressed: (){
                            isSearchButtonClicked = !isSearchButtonClicked;
                            (mounted)?setState(() {
                              studentsToShow = students;
                            }):null;
                          } , icon: Icon(Icons.search_rounded)
                      ),
                    ),
                    Expanded(
                      // flex:2,
                      child: IconButton(
                          onPressed: (){

                          } , icon: Icon(Icons.more_vert)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),10),

          (isSearchButtonClicked)
              ?Column(
            children: [
              placeASizedBoxHere(20),
              customPaddedRowWidget(TextField(
                onChanged: (s){
                  changeList(s);
                },
                autofocus: true,
                decoration:InputDecoration(
                    suffixIcon:IconButton(
                        onPressed: (){

                        } , icon: Icon(Icons.search_rounded)
                    ) ,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40)
                    )
                ),
              ), 15)
            ],
          )
              :Text(""),
          placeASizedBoxHere(30),
          (isFetching)
          ?loadingPage()
          :Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
            return ExpansionTile(
              title: Text(studentsToShow?.elementAt(index)["roll_no"]),
              children: <Widget>[
                    ListTile(title: Row(
                      children: [
                        Expanded(
                            flex:2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name : " + studentsToShow?.elementAt(index)["first_name"] + " " + studentsToShow?.elementAt(index)["last_name"]),
                                placeASizedBoxHere(20),
                                Text("Class : "+studentsToShow?.elementAt(index)["std_id"]["std_name"]),
                              ],
                            )),
                        Expanded(
                            flex:1,
                            child: Text("")),
                        Expanded(
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(
                                CupertinoIcons.profile_circled,
                            size: 75),
                          ),
                        )
                      ],
                    )),

              ],
            );
                }, separatorBuilder: (BuildContext context, int index){
            return placeASizedBoxHere(0);
                }, itemCount: studentsToShow?.length ?? 0),
          )
        ],
      );
  }
}
