import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/Teacher Models/StudentModel.dart';
import 'MessageScreen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _loading = true;
  List<StudentModel> studentWithoutChatList= [];
  List<StudentModel> tempStudentList = [];
  bool _searchClicked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  implementSearch(String s){
    if(s.isEmpty){
      setState(() {
        tempStudentList = studentWithoutChatList;
      });
      return;
    }
    else {
      List<StudentModel> tempList = [];
      for (var element in studentWithoutChatList) {
        String name = element.firstName.toString() +" "+ element.lastName.toString();
        if (name.toLowerCase().contains(s.toLowerCase())) {
          // debugPrint(element.name);
          tempList.add(element);
        }
      }
      setState(() {
        tempStudentList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: (_searchClicked)?TextField(
            autofocus: true,
            onChanged: (s) {
              // debugPrint(s);
              implementSearch(s);
            },
            cursorColor: Colors.white,
            style: TextStyle(
                color: Colors.white
            ),
            decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                    color: Colors.white
                ),
                border: InputBorder.none
            ),
          ):Text(APP_NAME),
          leading: (_searchClicked) ? IconButton(
            onPressed: (){
              _searchClicked =
              !_searchClicked;
              setState(() {
                tempStudentList = studentWithoutChatList;
              });
            },
            icon: Icon(Icons.arrow_back,color: Colors.white),
          ) : null,
        ),
        body:  Column(
          children: [
            placeASizedBoxHere((_searchClicked)?0:50),
            (_searchClicked)?SizedBox(height: 0,width: 0,):customPaddedRowWidget(Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 30,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "New Chats",
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
                      Text("FIND YOUR STUDENTS")
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: IconButton(
                            onPressed: () {
                              _searchClicked =
                              !_searchClicked;
                              setState(() {
                                tempStudentList = studentWithoutChatList;
                              });
                            }, icon: Icon(Icons.search_rounded)
                        ),
                      ),
                      Expanded(
                        // flex:2,
                        child: IconButton(

                            onPressed: () {

                            }, icon: Icon(Icons.more_vert)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ), 10),
            placeASizedBoxHere(20),
            (_loading)
                ?loadingPage()
                :Expanded(
              child: ListView(
                  children:[ Column(
                    children: [
                      Column(
                        children: [
                          (tempStudentList.length != 0)
                              ?customPaddedRowWidget(ListView.builder(
                              itemCount: tempStudentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                            ),
                                            Container(
                                              height: 60,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text((tempStudentList.elementAt(index).firstName ?? " ")+" "+(tempStudentList.elementAt(index).lastName ?? " "),
                                                      style: TextStyle(
                                                          fontSize: 15
                                                      ),),
                                                    Text(tempStudentList.elementAt(index).rollNo ?? " ")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async{
                                    setState(() {
                                      _loading = true;
                                    });
                                    SharedPreferences pref= await SharedPreferences.getInstance();
                                    await postNewChat(pref.getString("teacher-id").toString(),tempStudentList.elementAt(index).id ?? ' ').then((v){
                                      setState(() {
                                        _loading = false;
                                      });
                                      return json.decode(v.body);
                                    }).then((chatId){
                                      Navigator.pushReplacement(_scaffoldKey.currentContext!, MaterialPageRoute(builder: (context)=>MessageScreen(chatId["_id"].toString(),(tempStudentList.elementAt(index).firstName ?? " ")+" "+(tempStudentList.elementAt(index).lastName ?? " "))));
                                    });
                                  },
                                );
                              }), 20)
                              :Container(
                              height: MediaQuery.of(context).size.height-200,
                              child: Center(child: Text("No Chat History... Add New!")
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                  ]
              ),
            ),
          ],
        )
    );
  }

  @override
  void initState() {
      getStudentsWithoutChat().then((value){
        setState(() {
          studentWithoutChatList = value;
          tempStudentList = value;
          _loading = false;
        });
      });
  }
}

class mychats extends StatefulWidget {
  const mychats({Key? key}) : super(key: key);

  @override
  State<mychats> createState() => _mychatsState();
}

class _mychatsState extends State<mychats> {
  var isSearchButtonClicked = false;
  var students;
  var studentsToShow;
  var flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (isSearchButtonClicked) ? IconButton(
          onPressed: (){
            isSearchButtonClicked =
            !isSearchButtonClicked;
            setState(() {
              studentsToShow = students;
            });
          },
          icon: Icon(Icons.arrow_back,color: Colors.white),
        ) : null,
        title: (isSearchButtonClicked)
            ?TextField(
          autofocus: true,
          onChanged: (s){
            List<StudentModel>? newStudents = [];
            for(var i in (students ?? [])) {
              var name = (i.firstName ?? " ")+" "+(i.lastName ?? " ");
              if (name.toLowerCase().contains(s.toLowerCase())) {
                newStudents.add(i);
              }
            }

            studentsToShow = newStudents;
            setState(() {

            });
          },
          cursorColor: Colors.white,
          style: TextStyle(
              color: Colors.white
          ),
          decoration:InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors.white
            ),
            hintText: "Search",
          ),
        )
            :Text(APP_NAME),
      ),
      body:Column(
        children: [
          placeASizedBoxHere((isSearchButtonClicked)?0:50),
          (isSearchButtonClicked)?SizedBox(height: 0,width: 0,):customPaddedRowWidget(Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 5,
                          height: 30,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "My Chats",
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
                    Text("FIND YOUR STUDENTS")
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () {
                            isSearchButtonClicked =
                            !isSearchButtonClicked;
                            setState(() {
                              studentsToShow = students;
                            });
                          }, icon: Icon(Icons.search_rounded)
                      ),
                    ),
                    Expanded(
                      // flex:2,
                      child: IconButton(

                          onPressed: () {

                          }, icon: Icon(Icons.more_vert)
                      ),
                    )
                  ],
                ),
              )
            ],
          ), 10),
          placeASizedBoxHere(20),
          Expanded(
            child: ListView(
              children:[ FutureBuilder<List<StudentModel>>(
                future: getMyChats(),
                builder: (BuildContext context,AsyncSnapshot<List<StudentModel>> snapshot){

                  if(flag){
                    students = snapshot.data;
                    studentsToShow = students;
                  }
                  List<Widget> children = [];
                  if(snapshot.hasError){
                    children=[
                      Text("Error")
                    ];
                  }
                  else if(snapshot.hasData){
                    children = [
                      (studentsToShow.length != 0)
                        ?customPaddedRowWidget(ListView.builder(
                          shrinkWrap: true,
                          itemCount: studentsToShow.length,
                          itemBuilder: (BuildContext context,int index){
                            return GestureDetector(
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: 80,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text((studentsToShow.elementAt(index).firstName ?? " ")+" "+(studentsToShow.elementAt(index).lastName ?? " "),
                                                  style: TextStyle(fontSize: 17.5,),
                                              ),
                                              Text(studentsToShow.elementAt(index).rollNo ?? " ",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(studentsToShow.elementAt(index).chat_id ?? " ", (studentsToShow.elementAt(index).firstName ?? " ")+" "+(studentsToShow.elementAt(index).lastName ?? " "))));
                              },
                            );
                          }),20
                        ):Container(
                          height: MediaQuery.of(context).size.height-200,
                          child: Center(child: Text("No Chat History... Add New!")
                          )
                      ),
                    ];
                    flag = false;
                  }
                  else{
                    children =  <Widget>[
                      loadingPage()
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:children,
                    ),
                  );

                },

              ),
              ]
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
