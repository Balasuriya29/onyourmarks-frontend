import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../ApiHandler/Student/StudentsAPIs.dart';
import '../../../Models/Student Models/SubjectModel.dart';
import '../../../Models/Student Models/ExamModel.dart';
import '../../../Utilities/Components/functional.dart';

class MyExams extends StatefulWidget {
  const MyExams({Key? key}) : super(key: key);

  @override
  State<MyExams> createState() => _MyExamsState();
}

class _MyExamsState extends State<MyExams> with TickerProviderStateMixin {
  var calenderController = CalendarController();
  List<ExamModel> exams = [];
  List<List<SubjectModel>> subjects = [];
  DateTime futureFirstDate = DateTime.now();
  bool isFetching = true;
  bool flag = true;
  getExamsFunc() async {
    exams = await getMyExams();
    for(var i in exams){
      List<SubjectModel> tempList = [];

      if(futureFirstDate.compareTo(DateTime.parse(i.subjects?.first.date ?? "")) == -1 && flag){
        futureFirstDate = DateTime.parse(i.subjects?.first.date ?? "");
        flag = false;
      }
      if(futureFirstDate.compareTo(DateTime.parse(i.subjects?.first.date ?? "")) == -1 && flag){
        futureFirstDate = DateTime.parse(i.subjects?.first.date ?? "");
        flag = false;
      }
      tempList.addAll(i.subjects ?? []);
      subjects.add(tempList);
    }
    (mounted)?setState(() {
      isFetching = false;
    }):null;
  }

  @override
  void initState() {
    // super.initState();
    getExamsFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeASizedBoxHere(50),
        getHeader("EXAMS", "FIND YOUR EXAMS HERE!!!"),
        placeASizedBoxHere(50),
        (isFetching)
            ?loadingPage()
            :customPaddedRowWidget(Text("Upcoming Exam for you is: "+futureFirstDate.toString().substring(0,10), style: TextStyle(
          fontSize: 15,

        ),), 10),
        placeASizedBoxHere(50),
        (isFetching)
            ?Text("")
            :Expanded(
          child: customPaddedRowWidget(SfCalendar(
            view: CalendarView.month,
            controller: calenderController,
            showDatePickerButton: true,
            allowViewNavigation: true,
            dataSource: MeetingDataSource(_getDataSource(subjects , exams)),
            monthViewSettings: const MonthViewSettings(showAgenda: true),
            timeSlotViewSettings: const TimeSlotViewSettings(
                minimumAppointmentDuration: Duration(minutes: 60)),
          ), 10),
        ),
      ],
    );
  }
}

List<Meeting> _getDataSource(List<List<SubjectModel>>? subjects, List<ExamModel> exams) {
  final List<Meeting> meetings = <Meeting>[];
  int examCounter = 0;
  for(var i in subjects!){
    var examName = exams.elementAt(examCounter++).examName;

    for(var j in i){
      var subName = j.subName ?? "";
      var date = DateTime.parse(j.date ?? "");
      DateTime startTime = DateTime(date.year, date.month, date.day, 9, 0, 0);
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
