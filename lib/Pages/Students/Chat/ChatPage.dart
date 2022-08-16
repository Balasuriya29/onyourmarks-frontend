import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiHandler/Student/ChatAPIs.dart';
import '../../../ApiHandler/Teacher/apiHandler.dart';
import '../../../Models/Student Models/TeacherModel.dart';
import '../../../Utilities/Components/functional.dart';

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
      setState(() {
        tempTeacherList = teacherContacts;
      });
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
      setState(() {
        tempTeacherList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: (_searchClicked)?TextField(
            autofocus: true,
            onChanged: (s) {
              debugPrint(s);
                implementSearch(s);
            },
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none
            ),
          ):Text(""),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: (_isLoading)?Center(child: CircularProgressIndicator(),)
            :SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 6,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 4,
                                height: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text("Contacts",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(child: IconButton(onPressed: (){
                            setState(() {
                              _searchClicked = !_searchClicked;
                            });
                          }, icon: Icon(CupertinoIcons.search))),
                          Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: Card(
                  elevation:2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: tempTeacherList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(),
                                    Container(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(tempTeacherList.elementAt(index).name ?? " "),
                                            Text(tempTeacherList.elementAt(index).degree ?? " ")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 1,thickness: 0.6,)
                              ],
                            ),
                            onTap: () async{
                              setState(() {
                                _isLoading = true;
                              });
                              SharedPreferences pref= await SharedPreferences.getInstance();
                              await postNewChat(teacherContacts.elementAt(index).id ?? " ",pref.getString("student-id").toString()).then((v){
                                setState(() {
                                  _isLoading = false;
                                });
                                return json.decode(v.body);
                              }).then((chatId){
                                Navigator.pushReplacement(_scaffoldKey.currentContext!, MaterialPageRoute(builder: (context)=>MessageScreen(chatId["_id"].toString())));
                              });
                            },
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }

  @override
  void initState() {
    getTeachersWithoutChat().then((value){
      setState(() {
        _isLoading = false;
        teacherContacts = value;
        tempTeacherList = value;
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
  bool _loading = true;

  futureBuilder(){
    return FutureBuilder<List<TeacherModel>>(
      future: getMyChatsForStudents(),
      builder: (BuildContext context,AsyncSnapshot<List<TeacherModel>> snapshot){
        List<Widget> children = [];
        if(snapshot.hasError){
          children=[
            Text("Error")
          ];
        }
        else if(snapshot.hasData){
          children = [
            (snapshot.data?.isNotEmpty == true)?Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        child: Card(
                          child: Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?.elementAt(index).name ?? " ",
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(snapshot.data?.elementAt(index).chat_id ?? " "))).then((value) {
                            build(context);
                          });
                        },
                      );
                    }),

              ),
            ):Center(child: Text("You haven't chatted with anyone"),)
          ];
        }
        else{
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:children,
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("MyChat"),
      body:futureBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
      futureBuilder();
  }
}
