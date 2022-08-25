import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';

import '../../../Utilities/functions.dart';

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
    texts[42],
    texts[43],
    texts[44],
    texts[45],
    texts[46],
    texts[47]
  ];
  List<List<String>> subjects = [
    [texts[48], texts[49], texts[50], texts[51], texts[52], texts[53]],
    [texts[48], texts[54], texts[50], texts[52], texts[51], texts[49]],
    [texts[48], texts[49], texts[50], texts[53], texts[52], texts[48]],
    [texts[48], texts[49], texts[51], texts[50], texts[53], texts[51]],
    [texts[48], texts[49], texts[52], texts[53], texts[51], texts[48]],
    [texts[48], texts[49], texts[53], texts[51], texts[50], texts[52]],
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
          getHeader(texts[40], texts[41]),
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
