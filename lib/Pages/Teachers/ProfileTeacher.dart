import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var myDetails;
  String classes = "", subjects = "";
  String appBarEmote = "";
  var isFetching = true;
  var size = 0;
  getMyDetails() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    myDetails = json.decode(preferences.getString("personalDetails") ?? " ");
    var temp = json.decode(preferences.getString("teacherStandardObjects") ?? " ");
    var temp2 = json.decode(preferences.getString("teacherSubjectsObjects") ?? " ");

    for(var i=0;i<temp.length;i++){
      var std = json.decode(temp[i]);
      var sub = json.decode(temp2[i]);
      classes = classes +" ${i+1}. "+std["std_name"] +" - "+ sub["sub_name"]+"\n" +"\n";
      size += 75;
    }

    setState(() {
      print(myDetails["gender"]);
      if(myDetails["gender"] == 'Male') appBarEmote = "👨‍🏫";
      if(myDetails["gender"] == 'Female') appBarEmote = "👩‍🏫";
      isFetching = false;
    });
  }

  @override
  void initState() {
    getMyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Profile"+appBarEmote),
      body: (isFetching)
       ?loadingPage()
       :ListView(
         children:[
             Container(
              // height: MediaQuery.of(context).size.height * (1/3) - 25,
                 color: Colors.lightBlue.shade700,
                 child: Row(
                   children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 28.0),
                           child: populateCardsWithSubjectDetails("Name : ", 17, myDetails["name"], 17),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 18.0),
                           child: populateCardsWithSubjectDetails("Position : ", 17, "Teacher", 17),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 18.0,bottom: 28.0),
                           child: populateCardsWithSubjectDetails("Degree : ", 17, myDetails['degree'], 17),
                         ),
                       ],
                     ),
                     SizedBox(
                       width: 30,
                     ),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         CircleAvatar(
                           radius: 50,
                           child: Icon(
                               CupertinoIcons.profile_circled,
                               size: 100,
                           ),
                         )
                       ],
                     )
                   ],
                 )
             ),
             placeASizedBoxHere(50),
             Column(
               children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Container(
                     width: 325,
                     height: double.parse(size.toString()),
                     color: Colors.grey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 18.0),
                           child: getTheStyledTextForExamsList("Classes & Subjects Incharge",20),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 28.0,bottom: 8.0),
                           child: getTheStyledTextForExamsList(classes, 15),
                         ),
                       ],
                     ),
                   ),
                 ),
                 placeASizedBoxHere(50),
                 ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Container(
                     width: 325,
                     height: 200,
                     color: Colors.grey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 18.0),
                           child: getTheStyledTextForExamsList("Contact Details",20),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 18.0,left: 18.0,top: 28.0,bottom: 8.0),
                           child: Row(
                             children: [
                               getTheStyledTextForExamsList("Phone No : ", 15),
                               getTheStyledTextForExamsList(myDetails["phoneNo"].toString(), 15),
                             ],
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(18.0),
                           child: Row(
                             children: [
                               getTheStyledTextForExamsList("Email : ", 15),
                               getTheStyledTextForExamsList(myDetails["email"], 15)
                             ],
                           ),

                         )
                       ],
                     ),
                   ),
                 ),
                 placeASizedBoxHere(50),
               ],
             ),
         ]
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.chat_rounded),
      ),
    );
  }
}
