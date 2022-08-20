import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Models/Teacher%20Models/ExamModel.dart';
import 'package:onyourmarks/Pages/LoginPage.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Models/Student Models/CCAModel.dart';
import '../../Models/Student Models/MarksModel.dart';
import '../../Pages/Students/CCA/CCAForm.dart';
import '../../main.dart';
import '../functions.dart';
import '../staticNames.dart';
import 'class.dart';

AppBar getAppBar(String name){
  return AppBar(
    title: Text(name),
  );
}

Expanded placeAExpandedHere(int flex){
  return Expanded(flex:flex , child: Text(""),);
}

Expanded getExpanded(int flex, Widget child){
  return Expanded(
      flex: flex,
      child: child
  );
}

SizedBox placeASizedBoxHere(double height){
  return SizedBox(height: height);
}

Row populateCardsWithSubjectDetails(String field,double fieldSize,String? value,double valueSize){
  return Row(
    children: [
      getTheStyledTextForExamsList(field,fieldSize, Colors.white),
      getTheStyledTextForExamsList(value,valueSize,Colors.white),
    ],
  );
}

ListView populateExamsObjectToListView(BuildContext context, List<ExamModel> exams, String type){
  var color = (type == "upcoming")
      ?Colors.blue
      :(type == "in progress")
      ?Colors.green
      :Colors.amber;
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExamDetailsView(exams.elementAt(index),color)));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left:18.0),
                            child: getTheStyledTextForExamsList(exams.elementAt(index).examName.toString(),20,Colors.white)
                        ),
                        SizedBox(
                          width: 75,
                        ),
                        getTheStyledTextForExamsList(exams.elementAt(index).std_name.toString(),20,Colors.white)
                      ],
                    ),
                    placeASizedBoxHere(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: getTheStyledTextForExamsList("From : ", 15,Colors.white),
                        ),
                        getTheStyledTextForExamsList(exams.elementAt(index).subjects?.first.date?.substring(0,10) ?? ' ', 15,Colors.white),
                      ],
                    ),
                    placeASizedBoxHere(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: getTheStyledTextForExamsList("To : ", 15, Colors.white),
                        ),
                        getTheStyledTextForExamsList(exams.elementAt(index).subjects?.last.date?.substring(0,10) ?? ' ', 15, Colors.white)
                      ],
                    )
                  ],
                ),
              ),
              color: color,
            ),
          ),
        );

      }
      , separatorBuilder: (BuildContext context, int index){
    return SizedBox(
      height: 20,
    );
  }
      , itemCount: exams.length);
}

Text getTheStyledTextForExamsList(String? field, double fontSize, Color colors){
  return Text(field ?? ' ', style: TextStyle(color: colors, fontWeight: FontWeight.bold, fontSize: fontSize),);
}

Center loadingPage(){
  return Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      placeASizedBoxHere(20),
      Text("Loading Data")
    ],
  ));
}

Widget populateCCAObjectToListView(BuildContext context, List<CCAModel> activities, String type){
  var color = (type == "pending")
      ?Colors.blue
      :(type == "accepted")
      ?Colors.green
      :Colors.amber;

  int len = activities.length-1;
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return (type == "pending" && index == len)
            ?GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0,left: 18.0,right: 18.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).name.toString(),20)),
                              Expanded(
                                  flex: 1,
                                  child: Text("")
                              ),
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).status.toString(),20))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Type : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).type ?? ' ', 15),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Status : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).isVerified ?? ' ', 15)
                          ],
                        ),

                      ],
                    ),
                  ),
                  color: color,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(17.5)
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCCAForm()));
                    }, child: Icon(CupertinoIcons.add))
              ],
            ),
          ),
        )
            :GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0,left: 18.0,right: 18.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).name.toString(),20)),
                              Expanded(
                                  flex: 1,
                                  child: Text("")
                              ),
                              Expanded(
                                  flex: 3,
                                  child: getTheStyledTextForCCAList(activities.elementAt(index).status.toString(),20))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Type : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).type ?? ' ', 15),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: getTheStyledTextForCCAList("Status : ", 15),
                            ),
                            getTheStyledTextForCCAList(activities.elementAt(index).isVerified ?? ' ', 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: color,
                ),
              ],
            ),
          ),
        );
      }
      , separatorBuilder: (BuildContext context, int index){
    return SizedBox(
      height: 20,
    );
  }
      , itemCount: activities.length);
}

Text getTheStyledTextForCCAList(String? field, double fontSize){
  return Text(field ?? ' ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),);
}

Padding getsideCards(Icon icon, String title2, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
    child: Material(
      borderRadius: BorderRadius.circular(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            child: icon,
          ),
          Expanded(
            child: ListTile(
              title: Text(title2),
            ),
          ),
        ],
      ),
    ),
  );
}

List<Widget> getImageSlider(List<String> imagesList){
  List<Widget> imageSliders = imagesList
      .map((item) => Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.asset(item, fit: BoxFit.cover, width: 1000.0,alignment: Alignment.center),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ))
      .toList();
  return imageSliders;
}

SizedBox populateTheEvents(String? title, String? content, String? category){
  return SizedBox(
      width: 200,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                elevation: 2,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 150,
                        minWidth: 400
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 38.0,top: 8.0,right: 38.0),
                      child: ListTile(
                        title: Text(title ?? "",  style: TextStyle(fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                        subtitle: Text(content ?? "", maxLines: 3,),
                      ),
                    )
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Icon(
                CupertinoIcons.bookmark_fill,
                color: Colors.deepOrange,
                size: 30,
              ),
            ),
          ],
        ),
      )
  );
}

Column getBottomDrawerNavigation(context){
  return Column(
    children: [
      GestureDetector(
          onTap: (){

          },
          child: getsideCards(Icon(Icons.settings) , 'Settings', context)
      ),
      GestureDetector(
          onTap: (){
            Navigator.pop(context);
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                content: Text("Do you want to log out?"),
                actions: [
                  TextButton(onPressed: () async{
                    popPagesNtimes(context,1);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }, child: Text("YES")),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text("NO"))
                ],
              );
            });
          },
          child: getsideCards(Icon(Icons.logout) , 'Log Out', context)
      ),
    ],
  );
}

Row customPaddedRowWidget(Widget mainWidget, int customFlex){
  return Row(
    children: [
      Expanded(child: Text("")),
      Expanded(
        flex: customFlex,
        child: mainWidget,
      ),
      Expanded(child: Text(""))
    ],
  );
}

TableRow getTableRow(Widget fieldWidget, Widget valueWidget, String align1, String align2){
  return TableRow(
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    children: <Widget>[
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 128,
          minHeight: 54,
        ),
        child: Row(
          mainAxisAlignment: (align1 == "center")
                                ?MainAxisAlignment.center
                                :MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: fieldWidget,
            ),
          ],
        ),
      ),
      ConstrainedBox(
          child: Row(
            mainAxisAlignment: (align2 == "center")
                ?MainAxisAlignment.center
                :MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: valueWidget,
              ),
            ],
          ),
          constraints: BoxConstraints(
              minWidth: 128,
              minHeight: 54
          )
      )
    ],
  );
}

Padding getSubjectMarksStack(String subjectName, String subjectPercent, int sizePercent){
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subjectName.toUpperCase(), style: TextStyle(
          fontWeight: FontWeight.bold,
          // fontSize: 17.5,
        ),),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: ColoredBox(
                color: Colors.blue.shade900,
                child: SizedBox(
                  width:100,
                  height: 25,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                flex: sizePercent,
                                child: Container(
                                  color: Colors.orange,
                                  height: 20,
                                )
                            ),
                            Expanded(
                                flex: 10 - sizePercent,
                                child: Text("")
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: Text(subjectPercent + "%",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.5
            ),))
          ],
        )
      ],
    ),
  );
}

String? getSubjectName(String subName) {
  int index = getStartIndexToRemove(subName);
  var subjectName = (index != -1)
      ?subName.substring(0,index)
      :subName;
  return subjectName;
}

int getStartIndexToRemove(String subName) {
  int index = subName.indexOf(RegExp(r'[0-9]'));
  return index;
}

List<DoughnutSeries<ChartSampleData, String>> getDefaultDoughnutSeries(List<MarksModel> marks) {
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        radius: '80%',
        explode: true,
        // strokeWidth: 1000,
        explodeOffset: '10%',
        dataSource: getTheChartSegments(marks),
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(isVisible: true))
  ];
}

List<ChartSampleData> getTheChartSegments(List<MarksModel> marks){
  List<ChartSampleData> list = [];

  for(int i=0;i<marks.length;i++){
    var valueY = int.parse(marks[i].obtained_marks!)/6;
    list.add(ChartSampleData(x: marks[i].sub_name, y: valueY,text: ' ',));
  }

  return list;
}

List<Widget> getAllStackSubjects(Map<String, List<MarksModel>> currentMarks){
  List<Widget> list = [];
  var marksObject = currentMarks.values.toList();

  for(var i=0;i<marksObject[0].length;i++){
    var mark = marksObject[0].elementAt(i).obtained_marks ?? "0";
    var markInt = int.parse(mark);
    var sizePercent = (markInt > 50)
        ?(markInt/10).floor()
        :(markInt/10).ceil();

    String? subjectName = getSubjectName(marksObject[0].elementAt(i).sub_name ?? "");
    list.add(getSubjectMarksStack(
        subjectName ?? "",
        mark,
        sizePercent)
    );
  }
  return list;
}

List<DoughnutSeries<ChartSampleData, String>> getSemiDoughnutSeries() {
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: '', y: 59, text: null),
          ChartSampleData(x: '', y: 41, text: null),
        ],
        innerRadius: '50%',
        radius: '100%',
        startAngle: 270,
        endAngle: 90,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}

List<ChartData> getChartDataForGraph(List<MarksModel> marks, BuildContext context){
  List<ChartData> list = [];
  List<MaterialColor> list2 = [Colors.red, Colors.blue,Colors.green,Colors.deepPurple,Colors.pink, Colors.orange];
  for(var i=0;i<marks.length;i++){
    var subjectName = (MediaQuery.of(context).size.height < MediaQuery.of(context).size.width)
        ? getSubjectName(marks.elementAt(i).sub_name ?? "") ?? ""
        : getSubjectName(marks.elementAt(i).sub_name ?? "")?.substring(0,2) ?? "";
    list.add(
        ChartData(
            subjectName.toUpperCase(),
            double.parse(marks.elementAt(i).obtained_marks ?? "0"),
            list2[i]
        )
    );
  }
  return list;
}

List<LineSeries<ChartData, String>> getMultiColoredLineSeries(List<MarksModel> marks, BuildContext context) {
  return <LineSeries<ChartData, String>>[
    LineSeries<ChartData, String>(
        animationDuration: 2500,
        dataSource: getChartDataForGraph(marks, context),
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y,

        /// The property used to apply the color each data.
        pointColorMapper: (ChartData sales, _) => sales.lineColor,
        width: 2)
  ];
}

List<ChartDataForCCA> getChartDataForCCA(List<CCAModel> models){
  List<ChartDataForCCA> list = [];
  var participated = 0;
  var winner = 0;

  for(int i=0;i<models.length;i++){
    if(models.elementAt(i).isVerified == "accepted") {
      if (models
          .elementAt(i)
          .status == "Participation") {
        participated += 1;
      }
      if (models
          .elementAt(i)
          .status == "Winner") {
        winner += 1;
      }
    }

  }
  list.add(ChartDataForCCA("Participated",double.parse(participated.toString())));
  list.add(ChartDataForCCA("Winner", double.parse(winner.toString())));

  return list;
}

List<DateTime> getBlackoutDates() {
  final List<DateTime> dates = <DateTime>[];
  final DateTime startDate = DateTime.now().add(const Duration(days: 1));
  final DateTime endDate = DateTime.now().add(const Duration(days: 500));
  for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
      dates.add(date);
  }
  return dates;
}

bool selectableDayPredicateDates(DateTime date) {
  if (date.weekday == DateTime.sunday || date.compareTo(DateTime.now()) == 1) {
    return false;
  }

  return true;
}

bool selectableDayPredicateDatesForHW(DateTime date) {
  if (date.weekday == DateTime.sunday || date.compareTo(DateTime.now()) == 1) {
    if(DateTime.now().add(Duration(days: 1)).toString().substring(0,10) == date.toString().substring(0,10)){
      return true;
    }
    return false;
  }

  return true;
}

Color getMonthCellBackgroundColor(DateTime date, List<dynamic> attendance) {
  if (date.weekday == DateTime.sunday) {
    return Colors.yellow;
  }

  else if(attendance.contains(date.toString().substring(0,10))){
    return kDarkGreen;
  }
  else{
    var today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    var current = DateTime(date.year,date.month,date.day);
    var attendanceTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,10);
    if(today.compareTo(current) == 0) {
      if (DateTime.now().compareTo(attendanceTime) == -1) {
        return Colors.white;
      }
    }
    if(DateTime.now().compareTo(date) == -1){
      return Colors.white;
    }
    else{
      return kDarkRed;
    }
  }


}

Color getCellTextColor(Color backgroundColor, DateTime date) {
  if (DateTime.now().compareTo(date) == -1 && date.weekday != DateTime.sunday) {
    return Colors.grey;
  }

  if (backgroundColor == kDarkGreen || backgroundColor == kDarkRed){
    return Colors.white;
  }

  return Colors.black;
}

List<BarSeries<ChartSampleData, String>> getTrackerBarSeries(List<MarksModel> marks, BuildContext context) {
  return <BarSeries<ChartSampleData, String>>[
    BarSeries<ChartSampleData, String>(
      dataSource: getColumnChartValues(marks, context),
      borderRadius: BorderRadius.circular(15),
      // spacing: 0,
      color: Colors.deepPurple,
      trackColor: Colors.deepPurple.shade200,
      isTrackVisible: true,
      dataLabelSettings: const DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
      xValueMapper: (ChartSampleData sales, _) => sales.x as String,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];
}

List<ChartSampleData> getColumnChartValues(List<MarksModel> marks, BuildContext context){
  List<ChartSampleData> list = [];
  for(int i=0;i<marks.length;i++){
    var subjectName = getSubjectName(marks.elementAt(i).sub_name ?? "");
    subjectName = (MediaQuery.of(context).size.height < MediaQuery.of(context).size.width)
        ? getSubjectName(marks.elementAt(i).sub_name ?? "") ?? ""
        : getSubjectName(marks.elementAt(i).sub_name ?? "")?.substring(0,2) ?? "";
    list.add(
        ChartSampleData(
            x: subjectName.toUpperCase(),
            y: int.parse(marks.elementAt(i).obtained_marks ?? "0")
        )
    );
  }

  return list;
}

Row getHeader(String title, String subtitle){
  return customPaddedRowWidget(Row(
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
                  title,
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
            Text(subtitle.toUpperCase())
          ],
        ),
      ),

    ],
  ),10);
}

