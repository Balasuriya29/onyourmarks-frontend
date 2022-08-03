import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../ApiHandler/Student/ChatAPIs.dart';
import '../../../Utilities/components.dart';
import '../../../Models/Student Models/ChatModel.dart';

class MessageScreen extends StatefulWidget {
  final String chat_id;
  const MessageScreen(this.chat_id,{Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = new TextEditingController();
  List<Chat> messages = [];
  getMessagesFromFB(String chat_id) async{
    List<Chat> messages1 = [];
    if(chat_id == null){
      return;
    }
    CollectionReference ref = await FirebaseFirestore.instance.collection("message");
    var res = await ref.orderBy("time").where("chat_id",isEqualTo: chat_id).snapshots();
    res.listen((event) async{
      messages.clear();
      var iter =await event.docs.iterator;
      while(iter.moveNext()){
        var data = iter.current.data() as Map<String,dynamic>;
        // print(data);
        Chat chat = new Chat(data["chat_id"], data["message"], data["person"]);
        // print(chat.message.runtimeType);
        messages1.add(chat);
      }
      setState(() {
        messages = messages1;
        // messageController.dispose();
        messageController.text = "";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Messeges"),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount:messages.length ,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: (messages.elementAt(index).person == "student")?CrossAxisAlignment.end:CrossAxisAlignment.start,
                    children: [
                          Container(
                            decoration: BoxDecoration(
                              color:Colors.grey,
                              borderRadius: BorderRadius.only(
                                topRight: (messages.elementAt(index).person == "student")?Radius.zero:Radius.circular(18),
                                topLeft: (messages.elementAt(index).person == "student")?Radius.circular(18):Radius.zero,
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(messages.elementAt(index).message ?? ''),
                                ),
                              ],
                            ),
                          ),

                    ],
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10,);
              },),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 20),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await postMessage(
                          messageController.text, widget.chat_id,
                          "student").then((v){
                        setState(() {
                          messageController.text = "";
                        });
                      });
                    },
                    icon: Icon(CupertinoIcons.arrow_right_circle_fill),
                  )
              ),
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    getMessagesFromFB(widget.chat_id);
  }
}

