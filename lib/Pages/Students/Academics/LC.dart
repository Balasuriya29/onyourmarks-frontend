import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';
import '../../Teachers/Chat/ChatPage.dart';
import '../Attendance/CalendarStudent.dart';

class LearningOutComes extends StatefulWidget {
  const LearningOutComes({Key? key}) : super(key: key);

  @override
  State<LearningOutComes> createState() => _LearningOutComesState();
}

class _LearningOutComesState extends State<LearningOutComes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[0]),
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
      body: ListView(
        children: [Column(
          children: [
            placeASizedBoxHere(50),
            customPaddedRowWidget(Row(
              children: [
                Expanded(
                  flex:4,
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
                            "LEARNING OUTCOMES",
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
                      Text("TRACK YOUR PROGRESS".toUpperCase())
                    ],
                  ),
                ),
              ],
            ),10),
            placeASizedBoxHere(30),
            ExpansionTile(
              title: Text("GO 1: Read and Memorizing"),
              collapsedBackgroundColor: Colors.red.shade100,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("SO 1: Associates words with pictures.", ),
                      subtitle: Text("Evaluvated Based of Activities", ),
                    ),
                    ListTile(
                      title: Text("SO 2: Names familiar objects seen in the pictures."),
                      subtitle: Text("Evaluvated Based of Activities", ),
                    ),
                    ListTile(
                      title: Text("SO 3: Reads words as a whole."),
                      subtitle: Text("Evaluvated Based of Activities", ),
                    ),

                    Container(
                      color: Colors.red.shade100,
                      child: ListTile(
                        title: Text("SO 4: Differentiates between small and capital letters in print."),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Evaluvated Based of Academic",),
                            Text("FeedBack: Needs Clarity",),
                          ],
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 5: Enjoys, recites rhymes, poems, songs with actions."),
                    )
                  ],
                )
              ],
            ),
            ExpansionTile(
              collapsedBackgroundColor: Colors.green.shade100,
              title: Text("GO 2: New Words"),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 1: Identifies characters and sequence of a story.", ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 2: Identifies characters and sequence of a story."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 3: Listens to English words, greetings, polite forms of expressions, simple sentences and responds in English."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 4: Repeats words and sentences correctly after the teacher."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 5: Learns new words."),
                    )
                  ],
                )
              ],
            ),
            ExpansionTile(
              title: Text("GO 3: Writing"),
              collapsedBackgroundColor: Colors.green.shade100,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 1: Reads words, phrases and simple sentences correctly.", ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 2: Says words with proper stress and intonation."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 3: Says words with proper stress and intonation"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 4: Identifies and writes the letters of the alphabets correctly."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("SO 5: Writes neatly and legibly."),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ]
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
