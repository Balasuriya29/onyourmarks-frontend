import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/components.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffe3e3),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          customPaddedRowWidget(Row(
            children: [
              Expanded(
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
                          "PROFILE",
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
                    Text("STUDENT DASHBOARD INDIVIDUAL")
                  ],
                ),
              ),
              CircleAvatar(
                minRadius: 30,
              )
            ],
          )),
          SizedBox(
            height: 40,
          ),
          customPaddedRowWidget(Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                flex:5,
                child: Container(
                  height: 175,
                  width: 50,
                  color: Colors.white,
                ),
              ),
              Expanded(child: Text("")),
              Expanded(
                flex:5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Attendance Percentage", style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              )
            ],
          )),
          SizedBox(
            height: 40,
          ),

        ],
      ),
    );
  }
}
