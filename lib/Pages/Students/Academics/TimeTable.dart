import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';

class ScheduleSystem extends StatefulWidget {
  @override
  _TableExample createState() => _TableExample();
}

class _TableExample extends State<ScheduleSystem> {
  List<String> timeRange = [
    "9.00 AM To 10.00 AM",
    "10.00 AM To 11.00 AM",
    "11.00 AM To 12.00 AM",
    "12.00 PM To 1.00 PM",
    "1.00 PM To 2.00 PM",
    "2.00 PM To 3.00 PM",
  ];
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  List<List<String>> subjects = [
    ["Maths", "Physics", "English", "Tamil", "Chemistry", "Biology"],
    ["Maths", "PET", "English", "Tamil", "Chemistry", "Biology"],
    ["Maths", "Physics", "English", "Tamil", "Chemistry", "Biology"],
    ["Maths", "Physics", "English", "Tamil", "Chemistry", "Biology"],
    ["Maths", "Physics", "English", "Tamil", "Chemistry", "Biology"],
    ["Maths", "Physics", "English", "Tamil", "Chemistry", "Biology"],
  ];

  renderExpansionTile(String day, List<String> subjects) {
    return ExpansionTile(
      backgroundColor: Colors.deepPurple.shade50,
      title: Text(day),
      children: [
        for (int i = 0; i < timeRange.length; i++)
          timextask(timeRange.elementAt(i), subjects.elementAt(i)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          placeASizedBoxHere(50),
          getHeader("Weekly TimeTable", "SEE THE SCHEDULE COMING!"),
          placeASizedBoxHere(20),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < subjects.length; i++)
                  renderExpansionTile(days[i], subjects[i])
              ],
            ),
          ),
        ],
      ),
    );
  }

  timextask(String timerange1, String task1) {
    return ListTile(
      title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(timerange1)),
                Expanded(flex: 1, child: Text(":")),
                Expanded(flex: 2, child: Text(task1))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
