import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';

import '../../../Utilities/Components/functional.dart';
import '../../Teachers/Chat/ChatPage.dart';
import '../Attendance/CalendarStudent.dart';

class MyDetails extends StatefulWidget {
  const MyDetails(this.myDetails,{Key? key}) : super(key: key);
  final myDetails;
  @override
  State<MyDetails> createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarForAttendanceView()));
            }, icon: Icon(Icons.perm_contact_calendar)
            ),
          )
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            placeASizedBoxHere(50),
            getHeader("Profile", "YOUR DETAILS"),
            placeASizedBoxHere(20),
            customPaddedRowWidget(ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            Text(widget.myDetails["roll_no"]),
                            SizedBox(
                              height: 10,
                            ),
                            Text(widget.myDetails["first_name"]+" "+widget.myDetails["last_name"]),
                            SizedBox(
                              height: 10,
                            ),
                            Text(widget.myDetails["std_id"]["std_name"])
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ), 20),
            placeASizedBoxHere(20),
            customPaddedRowWidget(ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Center(child: Text("Personal Identification", style: TextStyle(fontSize: 20),))),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                                children:[
                                  Text("Date Of Birth : "),
                                  Text(widget.myDetails["dob"].toString().substring(0,10))
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Gender: "),
                                  Text(widget.myDetails["gender"])
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Blood Group: "),
                                  Text(widget.myDetails["bloodGroup"].toString())
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Mother Tongue: "),
                                  Text(widget.myDetails["motherTongue"])
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), 20),
            placeASizedBoxHere(20),
            customPaddedRowWidget(ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Center(child: Text("Personal Details", style: TextStyle(fontSize: 20),))),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                                children:[
                                  Text("Father's Name: "),
                                  Text(widget.myDetails["parent1name"])
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Mother's Name: "),
                                  Text(widget.myDetails["parent2name"])
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Occupation: "),
                                  Text(widget.myDetails["occupation"].toString())
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Income: "),
                                  Text(widget.myDetails["income"].toString())
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), 20),
            placeASizedBoxHere(20),
            customPaddedRowWidget(ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Center(child: Text("Other Details", style: TextStyle(fontSize: 20),))),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                                children:[
                                  Text("Permanent Address : "),
                                  Text(widget.myDetails["permanentAddress"]),
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Current Address : "),
                                  Text(widget.myDetails["currentAddress"]),
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Phone No: "),
                                  Text(widget.myDetails["phoneNo"].toString())
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                children:[
                                  Text("Email: "),
                                  Text(widget.myDetails["email"])
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ), 20),
            placeASizedBoxHere(50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.chat_bubble_text_fill),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>mychats()));
        },
      ),
    );
  }
}
