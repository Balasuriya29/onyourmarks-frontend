import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utilities/components.dart';

class MyDetails extends StatefulWidget {
  const MyDetails({Key? key}) : super(key: key);

  @override
  State<MyDetails> createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  var myDetails;
  var isFetching = true;

  getMyDetails() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    myDetails = jsonDecode(preferences.get("student-personalDetails").toString());
    setState(() {
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
      appBar: getAppBar("Your Details"),
      body:(isFetching)
        ?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Loading Data")
        ],
      ))
        :SingleChildScrollView(
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
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
                              Text(myDetails["roll_no"]),
                              SizedBox(
                                height: 10,
                              ),
                              Text(myDetails["first_name"]+" "+myDetails["last_name"]),
                              SizedBox(
                                height: 10,
                              ),
                              Text(myDetails["std_id"]["std_name"])
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
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
                                    Text(myDetails["dob"].toString().substring(0,10))
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Gender: "),
                                    Text(myDetails["gender"])
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Blood Group: "),
                                    Text(myDetails["bloodGroup"].toString())
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Mother Tongue: "),
                                    Text(myDetails["motherTongue"])
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
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
                                    Text(myDetails["parent1name"])
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Mother's Name: "),
                                    Text(myDetails["parent2name"])
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Occupation: "),
                                    Text(myDetails["occupation"].toString())
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Income: "),
                                    Text(myDetails["income"].toString())
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
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
                                    Text(myDetails["permanentAddress"]),
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Current Address : "),
                                    Text(myDetails["currentAddress"]),
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Phone No: "),
                                    Text(myDetails["phoneNo"].toString())
                                  ]
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children:[
                                    Text("Email: "),
                                    Text(myDetails["email"])
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
              ),
            ),
          ],
      ),
        ),
    );
  }
}
