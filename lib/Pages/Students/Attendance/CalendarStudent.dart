import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/ApiHandler/AttendanceAPIs.dart';
import 'package:onyourmarks/Utilities/Components/functional.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../Utilities/staticNames.dart';
import '../../Teachers/Chat/ChatPage.dart';

class CalendarForAttendanceView extends StatefulWidget {
  const CalendarForAttendanceView({Key? key}) : super(key: key);

  @override
  State<CalendarForAttendanceView> createState() =>
      _CalendarForAttendanceViewState();
}

class _CalendarForAttendanceViewState extends State<CalendarForAttendanceView> {
  var dates;
  var isFetching = true;
  getMyDates() async {
    dates = await getMyAttendance();
    (mounted)
        ? setState(() {
            isFetching = false;
          })
        : null;
  }

  Widget _monthCellBuilder(
      BuildContext buildContext, MonthCellDetails details) {
    final Color backgroundColor =
        getMonthCellBackgroundColor(details.date, dates);
    final Color defaultColor = Colors.black54;
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: defaultColor, width: 0.5)),
      child: Center(
        child: (details.date.toString().substring(0, 10) ==
                DateTime.now().toString().substring(0, 10))
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.5, color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    details.date.day.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: getCellTextColor(backgroundColor, details.date),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Text(
                details.date.day.toString(),
                style: TextStyle(
                    color: getCellTextColor(backgroundColor, details.date),
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Column(
        children: [
          placeASizedBoxHere(50),
          Expanded(child: getHeader(texts[61], texts[62])),
          (isFetching)
              ? Expanded(flex: 5, child: loadingPage())
              : Expanded(
                  flex: 5,
                  child: customPaddedRowWidget(
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: SfCalendar(
                                  view: CalendarView.month,
                                  monthCellBuilder: _monthCellBuilder,
                                  showDatePickerButton: true,
                                  monthViewSettings: const MonthViewSettings(
                                    showTrailingAndLeadingDates: false,
                                  ),
                                  selectionDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                ),
                              ),
                              Text(
                                texts[63],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      10),
                ),
          Expanded(
            child: customPaddedRowWidget(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(width: 30, height: 50, color: kDarkGreen),
                      SizedBox(
                        width: 10,
                      ),
                      Text(texts[64])
                    ]),
                    Row(children: [
                      Container(width: 30, height: 50, color: kDarkRed),
                      SizedBox(
                        width: 10,
                      ),
                      Text(texts[65])
                    ]),
                    Row(children: [
                      Container(width: 30, height: 50, color: Colors.yellow),
                      SizedBox(
                        width: 10,
                      ),
                      Text(texts[66])
                    ]),
                  ],
                ),
                10),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getMyDates();
    
  }
}
