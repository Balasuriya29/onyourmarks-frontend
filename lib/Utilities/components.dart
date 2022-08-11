import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Models/Teacher%20Models/ExamModel.dart';
import 'package:onyourmarks/Pages/Teachers/MarkUpdationPages.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Models/Student Models/CCAModel.dart';
import '../Models/Student Models/MarksModel.dart';
import '../Pages/Students/CCA/CCAForm.dart';
import '../main.dart';

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
      getTheStyledTextForExamsList(field,fieldSize),
      getTheStyledTextForExamsList(value,valueSize),
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
                                      child: getTheStyledTextForExamsList(exams.elementAt(index).examName.toString(),20)
                                    ),
                                    SizedBox(
                                      width: 75,
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).std_name.toString(),20)
                                  ],
                                ),
                                placeASizedBoxHere(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: getTheStyledTextForExamsList("From : ", 15),
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).subjects?.first.date?.substring(0,10) ?? ' ', 15),
                                  ],
                                ),
                                placeASizedBoxHere(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: getTheStyledTextForExamsList("To : ", 15),
                                    ),
                                    getTheStyledTextForExamsList(exams.elementAt(index).subjects?.last.date?.substring(0,10) ?? ' ', 15)
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

Text getTheStyledTextForExamsList(String? field, double fontSize){
  return Text(field ?? ' ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),);
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

class BuildChoiceChips extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;
  const BuildChoiceChips(this.items,{required this.onSelectionChanged});

  @override
  State<BuildChoiceChips> createState() => _BuildChoiceChipsState();
}

class _BuildChoiceChipsState extends State<BuildChoiceChips> {

  List<String> selectedChoices = [];
  buildChoiceChips(){
    List<Widget> choices = [];
    widget.items.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          selectedColor: Colors.blue,
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
        ),
      ));
    });
    return choices;
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: buildChoiceChips(),
    );
  }
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 150,
                      minWidth: 400
                    ),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38.0,top: 8.0,right: 38.0),
                          child: ListTile(
                            title: Text(title ?? "",  style: TextStyle(fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                            subtitle: Text(content ?? "", maxLines: 3,),
                          ),
                        )

                    )
                ),
              ),
            ),
            Positioned(
              top: 10,
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

Padding getBottomDrawerNavigation(context){
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Column(
      children: [
        GestureDetector(
            onTap: (){

            },
            child: getsideCards(Icon(Icons.settings) , 'Settings', context)
        ),
        GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: getsideCards(Icon(Icons.logout) , 'Log Out', context)
        ),
      ],
    ),
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

TableRow getTableRow(String? field, String? value){
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

          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(field ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
      ConstrainedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(value ?? "",  style: TextStyle(fontWeight: FontWeight.w500),),
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

class CircularChart extends StatefulWidget {
  final marks;
  const CircularChart(this.marks,{Key? key}) : super(key: key);

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: SfCircularChart(
          margin: EdgeInsets.all(0),
          title: ChartTitle(text:''),
          series: _getDefaultDoughnutSeries(widget.marks),
          tooltipBehavior:TooltipBehavior(enable: true, format: 'point.x : point.y%'),
      ),
    );
  }

  @override
  void initState() {

  }
}

List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries(List<MarksModel> marks) {
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

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
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
    var subjectName = marksObject[0].elementAt(i).sub_name?.indexOf(new RegExp(r'[0-9]')) ?? "";


    list.add(getSubjectMarksStack(
        marksObject[0].elementAt(i).sub_name ?? "",
        mark,
        sizePercent));
  }
  return list;
}
