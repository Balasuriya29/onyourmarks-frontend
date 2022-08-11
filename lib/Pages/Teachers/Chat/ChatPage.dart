import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/Teacher/apiHandler.dart';
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
        body:  (_loading)?Center(
          child: CircularProgressIndicator(),
        ):SingleChildScrollView(
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
              (tempStudentList.isNotEmpty)?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: tempStudentList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Card(
                              child: Container(
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(tempStudentList.elementAt(index).firstName ?? " "),
                                      Text(tempStudentList.elementAt(index).rollNo ?? " ")
                                    ],
                                  ),
                                ),
                              ),
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
                                  Navigator.pushReplacement(_scaffoldKey.currentContext!, MaterialPageRoute(builder: (context)=>MessageScreen(chatId["_id"].toString())));
                              });
                            },
                          );
                        }),
                  ),
                ),
              ) :Center(child: Text("No Students"),),
            ],
          ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:FutureBuilder<List<StudentModel>>(
        future: getMyChats(),
        builder: (BuildContext context,AsyncSnapshot<List<StudentModel>> snapshot){
          List<Widget> children = [];
          if(snapshot.hasError){
            children=[
              Text("Error")
            ];
          }
          else if(snapshot.hasData){
            children = [
              Expanded(
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
                                Text(snapshot.data?.elementAt(index).firstName ?? " ",
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(snapshot.data?.elementAt(index).chat_id ?? " ")));
                      },
                    );
                  }),
                ),
              )
            ];
          }
          else{
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
