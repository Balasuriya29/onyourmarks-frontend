import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../ApiHandler/Student/ChatAPIs.dart';
import '../../../Models/Student Models/TeacherModel.dart';
import '../../../Utilities/Components/functional.dart';
import 'MessageScreen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar("Chat"),
        body: FutureBuilder<List<TeacherModel>>(
          future: getTeachersWithoutChat(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TeacherModel>> snapshot) {
              List<Widget> children = [];
              if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              }
              else if (snapshot.hasData) {
                children = [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      shrinkWrap: true,
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
                                      Text(snapshot.data?.elementAt(index).name ?? " "),
                                      Text(snapshot.data?.elementAt(index).degree ?? " ")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async{
                              await postNewChat(snapshot.data?.elementAt(index).id ?? " ","62de30c1bc6a3da7659b816c").then((v)=>{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen("")))
                              });
                            },
                          );
                        }),
                  )
                ];
              }
              else {
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
        ),
    );
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
      appBar: getAppBar("MyChat"),
      body:FutureBuilder<List<TeacherModel>>(
        future: getMyChats(),
        builder: (BuildContext context,AsyncSnapshot<List<TeacherModel>> snapshot){
          List<Widget> children = [];
          if(snapshot.hasError){
            children=[
              Text("Error")
            ];
          }
          else if(snapshot.hasData){
            children = [
              Padding(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(snapshot.data?.elementAt(index).chat_id ?? " ")));
                    },
                  );
                }),
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
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
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
