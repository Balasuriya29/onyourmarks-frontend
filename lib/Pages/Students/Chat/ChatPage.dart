import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiHandler/Student/ChatAPIs.dart';
import '../../../Models/Student Models/TeacherModel.dart';
import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';
import 'MessageScreen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TeacherModel> teacherContacts = [];
  List<TeacherModel> tempTeacherList = [];
  bool _searchClicked = false;

  implementSearch(String s){
    if(s.isEmpty){
      (mounted)?setState(() {
        tempTeacherList = teacherContacts;
      }):null;
     return;
    }
    else {
      List<TeacherModel> tempList = [];

      for (var element in teacherContacts) {
        if (element.name.toString().toLowerCase().contains(s.toLowerCase())) {
          // debugPrint(element.name);
          tempList.add(element);
        }
      }
      (mounted)?setState(() {
        tempTeacherList = tempList;
      }):null;
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
            decoration: InputDecoration(
              hintText: texts[81],
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
              (mounted)?setState(() {
                tempTeacherList = teacherContacts;
              }):null;
            },
            icon: Icon(Icons.arrow_back,color: Colors.white),
          ) : null,
        ),
        body: Column(
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
                                texts[82],
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
                          Text(texts[83])
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
                                  (mounted)?setState(() {
                                    tempTeacherList = teacherContacts;
                                  }):null;
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
                (_isLoading)
                    ?loadingPage()
                    :Expanded(
                  child: ListView(
                    children:[ Column(
                      children: [
                        Column(
                          children: [
                            customPaddedRowWidget(ListView.builder(
                                itemCount: tempTeacherList.length,
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
                                                      Text(tempTeacherList.elementAt(index).name ?? " ",
                                                        style: TextStyle(
                                                          fontSize: 15
                                                        ),),
                                                      Text(tempTeacherList.elementAt(index).degree ?? " ")
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
                                      (mounted)?setState(() {
                                        _isLoading = true;
                                      }):null;
                                      SharedPreferences pref= await SharedPreferences.getInstance();
                                      var chatId;
                                      await postNewChat(teacherContacts.elementAt(index).id ?? " ",pref.getString("student-id").toString()).then((v){
                                        (mounted)?setState(() {
                                          _isLoading = false;
                                        }):null;
                                        chatId = json.decode(v.body);
                                      });

                                        Navigator.pushReplacement(_scaffoldKey.currentContext!, MaterialPageRoute(builder: (context)=>MessageScreen(chatId["_id"].toString(), teacherContacts.elementAt(index).name ?? "")));

                                    },
                                  );
                                }), 20),
                          ],
                        ),
                      ],
                    ),
                    ]
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void initState() {
    getTeachersWithoutChat().then((value){
      (mounted)?setState(() {
        _isLoading = false;
        teacherContacts = value;
        tempTeacherList = value;
      }):null;
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
  var teachersToShow;
  var teachers;
  var flag;

  FutureBuilder getFutureBuilder(){
    return FutureBuilder<List<TeacherModel>>(
      future: getMyChatsForStudents(),
      builder: (BuildContext context,AsyncSnapshot<List<TeacherModel>> snapshot){
        if(flag){
          teachers = snapshot.data;
          teachersToShow = teachers;
        }
        List<Widget> children = [];
        if(snapshot.hasError){
          children=[
            Text("Error")
          ];
        }
        else if(snapshot.hasData){
          children = [
            (teachersToShow.length != 0)
                ?Column(
                  children: [
                    customPaddedRowWidget(ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teachersToShow.length,
                        itemBuilder: (BuildContext context,int index){
                        var color = Colors.white;
                          return GestureDetector(
                            onLongPress: (){
                              color = Colors.grey;
                              (mounted)?setState(() {

                              }):null;
                            },
                            child: Column(
                              children: [
                                Container(
                                  color: color,
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                        ),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(teachersToShow.elementAt(index).name ?? " ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(teachersToShow.elementAt(index).degree ?? " ",
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(teachersToShow.elementAt(index).chat_id ?? " ",teachersToShow.elementAt(index).name ?? " ")));
                            },
                          );
                        }), 20),
                  ],
            )
                :Container(
                  height: MediaQuery.of(context).size.height-200,
                  child: Center(child: Text(texts[80])
                )
              )
          ];
          flag = false;
        }
        else{
          children = <Widget>[
            Center(child: loadingPage())
          ];
        }
        return Column(
            children:children,
          );

      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (isSearchButtonClicked) ? IconButton(
          onPressed: (){
            isSearchButtonClicked =
            !isSearchButtonClicked;
            (mounted)?setState(() {
              teachersToShow = teachers;
            }):null;
          },
          icon: Icon(Icons.arrow_back,color: Colors.white),
        ) : null,
        title: (isSearchButtonClicked)
            ?TextField(
              autofocus: true,
              onChanged: (s){
                List<TeacherModel>? newTeachers = [];
                for(var i in (teachers ?? [])) {
                  if (i.name.toLowerCase().contains(s.toLowerCase())) {
                    newTeachers.add(i);
                  }
                }
                teachersToShow = newTeachers;
                (mounted)?setState(() {

                }):null;
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
                hintText: texts[81],
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
                         texts[84] ,
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
                    Text(texts[83])
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
                            (mounted)?setState(() {
                              teachersToShow = teachers;
                            }):null;
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
              children: [
                getFutureBuilder(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          flag = true;
          (mounted)?setState(() {

          }):null;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage())).then((value) {

            initState();
          });
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }

  @override
  void initState() {
    flag = true;
    getFutureBuilder();
  }

}
