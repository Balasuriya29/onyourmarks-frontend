
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../ApiHandler/Student/StudentsAPIs.dart';
import '../../../Models/Student Models/SubjectModel.dart';
import '../../../Utilities/components.dart';
import '../../../Models/Student Models/ExamModel.dart';

class MyExams extends StatefulWidget {
  const MyExams({Key? key}) : super(key: key);

  @override
  State<MyExams> createState() => _MyExamsState();
}

class _MyExamsState extends State<MyExams> with TickerProviderStateMixin {
  var calenderController = CalendarController();
  List<ExamModel> exams = [];
  List<List<SubjectModel>> subjects = [];
  DateTime? futureFirstDate;
  bool isFetching = true;
  getExamsFunc() async {
    exams = await getMyExams();
    futureFirstDate = DateTime.parse(exams.first.subjects?.first.date ?? "");
    for(var i in exams){
      List<SubjectModel> tempList = [];
      if(DateTime.parse(i.subjects?.first.date ?? "").compareTo(futureFirstDate!) == -1){
        futureFirstDate = DateTime.parse(tempList.first.date ?? "");
      }
      tempList.addAll(i.subjects ?? []);
      subjects.add(tempList);
    }
    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getExamsFunc();
  }

  @override
  Widget build(BuildContext context) {
    return (isFetching)
      ?loadingPage()
      :Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(

        children: [
          Expanded(
              flex: 2,
              child: Text("Your Exams",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
          Expanded(
              child: Text("Upcoming Exam for you is: "+futureFirstDate.toString().substring(0,10))),
          Expanded(
            flex: 10,
            child: SfCalendar(
              view: CalendarView.month,
              controller: calenderController,
              showDatePickerButton: true,
              allowViewNavigation: true,
              dataSource: MeetingDataSource(_getDataSource(subjects , exams)),
              monthViewSettings: const MonthViewSettings(showAgenda: true),
              timeSlotViewSettings: const TimeSlotViewSettings(
                  minimumAppointmentDuration: Duration(minutes: 60)),
            ),
          ),

        ],
      )
      );
  }
}

List<Meeting> _getDataSource(List<List<SubjectModel>>? subjects, List<ExamModel> exams) {
  final List<Meeting> meetings = <Meeting>[];
  int examCounter = 0;
  for(var i in subjects!){
    int dateInc = 0;
    final DateTime today = DateTime.parse(i.first.date ?? "");
    var examName = exams.elementAt(examCounter++).examName;
    for(var j in i){
      var subName = j.subName ?? "";
      DateTime startTime = DateTime(today.year, today.month, today.day + dateInc++, 9, 0, 0);
      DateTime endTime = startTime.add(const Duration(hours: 3));
      meetings.add(
          Meeting(examName!+ " - "+subName, startTime, endTime, Colors.green.shade900, false)
      );
    }
  }

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String? eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
