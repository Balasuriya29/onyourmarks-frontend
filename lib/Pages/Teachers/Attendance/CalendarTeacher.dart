import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/Teachers/Attendance/AttendanceSheet.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarForAttendance extends StatefulWidget {
  const CalendarForAttendance({Key? key}) : super(key: key);

  @override
  State<CalendarForAttendance> createState() => _CalendarForAttendanceState();
}

class _CalendarForAttendanceState extends State<CalendarForAttendance> {
  var blackoutDates;
  var dateController;

  @override
  void initState() {
    blackoutDates = getBlackoutDates();
    dateController = DateRangePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdfdfdf),
      appBar: getAppBar("Attendance"),
      body: Column(
        children: [
          placeASizedBoxHere(50),
          Expanded(
            child: customPaddedRowWidget(Row(
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
                            "Attendance",
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
                      Text("TEACHER ATTENDANCE POSTING CALENDAR")
                    ],
                  ),
                ),
                placeAExpandedHere(1)
              ],
            ),10),
          ),
          Expanded(
            flex: 5,
            child: customPaddedRowWidget(Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfDateRangePicker(
                  showActionButtons: true,
                    controller: dateController,
                    onSubmit: (v){
                      if(dateController.selectedDate == null){
                        toast("Please Select A Date!");
                        return;
                      }
                      print(dateController.selectedDate.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceSheet(selectedDate: dateController.selectedDate)));
                    },
                    monthCellStyle: const DateRangePickerMonthCellStyle(
                                blackoutDateTextStyle: TextStyle(
                                    color: Colors.red, decoration: TextDecoration.lineThrough)),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                    showTrailingAndLeadingDates: true,),
                    selectableDayPredicate: selectableDayPredicateDates,

                  ),
              ),
            ), 10
            ),
          ),
          placeAExpandedHere(1)
        ],
      ),
    );
  }
}
