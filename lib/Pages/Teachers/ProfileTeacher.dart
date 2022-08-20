import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import '../../Utilities/Components/functional.dart';
import 'Chat/ChatPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.me, this.stds_subs,{Key? key}) : super(key: key);
  final me;
  final stds_subs;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ListView getSubjectListView(var map){
    return ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(map.keys.toList().elementAt(index), style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),),
          getStdListView(map.values.toList().elementAt(index)),

        ],
      );
    }, separatorBuilder: (BuildContext context, int index){
      return placeASizedBoxHere(10);
    }, itemCount: map.length);
  }

  ListView getStdListView(var standards){
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(standards.elementAt(index).toString())
            ],
          );
        }, separatorBuilder: (BuildContext context, int index){
      return placeASizedBoxHere(5);
    }, itemCount: standards.length);
  }
  
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        children: [
          placeASizedBoxHere(50),
          getHeader("Profile", "YOUR DETAILS"),
          placeASizedBoxHere(20),
          Expanded(
            child: ListView(
            children:[
              customPaddedRowWidget(ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.blueGrey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Hero(
                            tag: "ProfilePic",
                            child: CircleAvatar(
                              radius: 50,
                              child:  Icon(
                                CupertinoIcons.profile_circled,
                                size: 100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.me["name"], style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.me["degree"],style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.me["facultyId"],style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), 20),
              placeASizedBoxHere(30),
              Column(
                children: [
                  customPaddedRowWidget(ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.shade50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 18.0),
                                  child: getTheStyledTextForExamsList("Classes & Subjects Incharge",17.5, Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 28.0,bottom: 8.0),
                                  child: getSubjectListView(widget.stds_subs),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), 20),
                  placeASizedBoxHere(30),
                  customPaddedRowWidget(ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 25.0),
                            child: getTheStyledTextForExamsList("Contact Details",17.5,Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Row(
                              children: [
                                getTheStyledTextForExamsList("Email ID : ", 15, Colors.black),
                                Text(widget.me["email"])
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                            child: Row(
                              children: [
                                getTheStyledTextForExamsList("Mobile No : ", 15, Colors.black),
                                Text(widget.me["phoneNo"].toString())
                              ],
                            ),
                          ),
                          placeASizedBoxHere(10)
                        ],
                      ),
                    ),
                  ), 20),
                ],
              ),
             ]
           ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>mychats()));
        },
        child: Icon(Icons.chat_rounded),
      ),
    );
  }
}
