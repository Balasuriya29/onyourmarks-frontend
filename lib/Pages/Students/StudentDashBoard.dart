import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onyourmarks/ApiHandler/Student/StudentsAPIs.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ApiHandler/Student/CCAAPIs.dart';
import '../../Models/Student Models/MarksModel.dart';
import '../../Utilities/Components/class.dart';
import '../../Utilities/Components/functional.dart';
import 'Academics/LC.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  //Page 1
  Map<String, dynamic>? me;
  var isFetchingPage1 = true;
  List<String>? keysOfMe = [];


  var fieldsName = [texts[8],texts[9],texts[10],texts[11],texts[12],texts[13],texts[14]];
  var valuesName = ["","roll_no","std_id","gender","parent1name","currentAddress","phoneNo"];

  getMyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    me = jsonDecode(preferences.getString("student-personalDetails").toString());
    keysOfMe = me?.keys.toList();
    var fName = me?["first_name"].toString() ?? "";
    var lName = me?["last_name"].toString() ?? "";
    valuesName[0] = fName+""+lName;
    for(var i in keysOfMe!){
      if(valuesName.contains(i)){
        int _index = valuesName.indexOf(i);
        if(i == "std_id"){
          valuesName[_index] = me?[i]["std_name"].toString() ?? "";
          continue;
        }
        valuesName[_index] = me?[i].toString() ?? "";
      }
    }

    (mounted)?setState(() {
      isFetchingPage1 = false;
      // print("Got Info");
    }):null;
  }

  //Page 2
  Map<String, List<MarksModel>> marksMap = {};
  Map<String, List<MarksModel>> currentMarks = {};
  var isFetchingPage2 = true;
  var gotCards = false;
  var mySubjectLength;

  getMarks() async {
    marksMap = await getMyMarks();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var me = jsonDecode(preferences.getString("student-personalDetails").toString());
    mySubjectLength = me["std_id"]["subject_id"].length;
    var marksObjects = marksMap.values.toList();
    var marksExams = marksMap.keys.toList();

    for(var i = marksObjects.length - 1;i>=0;i--){
      if(marksObjects.elementAt(i).length == mySubjectLength){
        currentMarks[marksExams.elementAt(i)] = marksObjects.elementAt(i);
        (mounted)?setState(() {}):null;
        break;
      }
    }
    (mounted)?setState(() {
      isFetchingPage2 = false;
      // print("Got Marks");
    }):null;
  }

  //Page 3
  var isFetchingPage3 = true;
  var activities;

  getCCA() async {
    activities = await getMyActivities();
    (mounted)?setState(() {
      isFetchingPage3 = false;
      // print("Got CCA");
    }):null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
        children : [
          SizedBox(
            height: 50,
          ),
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
                          texts[15],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(texts[16])
                  ],
                ),
              ),
              (isFetchingPage1)?Text(""):Expanded(
                child: CircleAvatar(
                  minRadius: 30,
                  child: Text(valuesName[0].substring(0,1).toUpperCase(), style: TextStyle(
                      fontSize: 30
                  ),),
                ),
              )
            ],
          ),10),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?loadingPage()
              :StudentDashBoard_1(me: me, isFetchingPage1: isFetchingPage1, fieldsName: fieldsName, keysOfMe: keysOfMe, valuesName: valuesName,),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?Text("")
              :StudentDashBoard_2(currentMarks: currentMarks, gotCards: gotCards, isFetchingPage2: isFetchingPage2, marksMap: marksMap, me: me),
          (isFetchingPage1 || isFetchingPage2 || isFetchingPage3)
              ?Text("")
              :StudentDashBoard_3(activities: activities,currentMarks: currentMarks,isFetchingCCA: isFetchingPage3,)
        ]
      ),
    );
  }

  @override
  void initState() {
    getMyInfo()
        .then((v1) => getMarks())
        .then((v2) => getCCA());
  }
}

class StudentDashBoard_1 extends StatefulWidget {
  const StudentDashBoard_1({
    Key? key,
    required this.me,
    required this.isFetchingPage1,
    required this.keysOfMe,
    required this.fieldsName,
    required this.valuesName,
  }) : super(key: key);
  final me;
  final isFetchingPage1;
  final keysOfMe;
  final fieldsName;
  final valuesName;
  @override
  State<StudentDashBoard_1> createState() => _StudentDashBoard_1State();
}

class _StudentDashBoard_1State extends State<StudentDashBoard_1> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          customPaddedRowWidget(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex:4,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 175,
                        width: 50,
                        color: Colors.transparent,
                        child: Image.asset('Images/DashBoard-Image.png')
                      ),
                    ),
                  ],
                )
              ),
              Expanded(
                flex:5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 200,
                      // color: Colors.red,
                      child: SfCircularChart(
                        title: ChartTitle(text: texts[17],textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        series: getSemiDoughnutSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    )
                  ],
                ),
              )
            ],
          ), 10),
          customPaddedRowWidget(Column(
            children: [
              Table(
                border: TableBorder.all(
                    borderRadius: BorderRadius.circular(5),
                    width: 1.25
                ),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FlexColumnWidth(),
                  5: FlexColumnWidth(),
                  6: FlexColumnWidth(),
                  7: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  for(var i=0;i<7;i++)
                    getTableRow(
                        Text(widget.fieldsName[i] ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.valuesName[i] ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                        "start", "start"
                    )
                ],
              )
            ],
          ),10),
          SizedBox(
            height: 40,
          ),
        ],
      );
  }
}

class StudentDashBoard_2 extends StatefulWidget {
  const StudentDashBoard_2({
    Key? key,
    required this.me,
    required this.gotCards,
    required this.isFetchingPage2,
    required this.currentMarks,
    required this.marksMap,
  }) : super(key: key);
  final me;
  final gotCards;
  final isFetchingPage2;
  final currentMarks;
  final marksMap;
  @override
  State<StudentDashBoard_2> createState() => _StudentDashBoard_2State();
}

class _StudentDashBoard_2State extends State<StudentDashBoard_2> {

  getTotalMark(List<MarksModel> list){
    var total = 0;
    for(var i in list){
      total = total + int.parse(i.obtained_marks ?? "0");
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeASizedBoxHere(30),
        customPaddedRowWidget(
            Row(
              children: [
                Expanded(
                  flex:4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(texts[18], style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),),
                      placeASizedBoxHere(20),
                      Text(widget.currentMarks.keys.first.toString().toUpperCase(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5
                      ),),
                      placeASizedBoxHere(30),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text((texts[19]+widget.me["first_name"]+" "+widget.me["last_name"]).toUpperCase(), style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                        ),),
                      ),
                      placeASizedBoxHere(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(texts[20]+widget.me["roll_no"], style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                        ),),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircularChart(widget.currentMarks.values.first),
                      placeASizedBoxHere(20),
                      Text((getTotalMark(widget.currentMarks.values.first)).toString() + "/" + (100*widget.currentMarks.values.first.length).toString(),style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                )
              ],
            ),10
        ),
        placeASizedBoxHere(25),
        customPaddedRowWidget(
            BarChartForStudentsMark(marks: widget.currentMarks.values.first),10
        ),
        placeASizedBoxHere(50)
      ],
    );
  }

}

class StudentDashBoard_3 extends StatefulWidget {
  const StudentDashBoard_3({
    Key? key,
    required this.activities,
    required this.isFetchingCCA,
    required this.currentMarks
  }) : super(key: key);
  final activities;
  final isFetchingCCA;
  final currentMarks;
  @override
  State<StudentDashBoard_3> createState() => _StudentDashBoard_3State();
}

class _StudentDashBoard_3State extends State<StudentDashBoard_3> {

  bool? _displayRSquare;
  bool? _displaySlopeEquation;
  String _slopeEquation = '';
  late double? _intercept;
  List<double>? _slope;
  late String _rSquare;
  late int periodMaxValue;
  List<String>? _trendlineTypeList;
  late String _selectedTrendLineType;
  late TrendlineType _type;
  late int _polynomialOrder;
  late int _period;
  TooltipBehavior? _tooltipBehavior;
  late bool isLegendTapped;
  Size? slopeTextSize;

  List<ColumnSeries<ChartSampleData, String>> _getTrendLineDefaultSeries() {
    periodMaxValue = 6; // dataSource.length - 1;
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(text: 'Sun', yValue: 12500),
            ChartSampleData(text: 'Mon', yValue: 14000),
            ChartSampleData(text: 'Tue', yValue: 22000),
            ChartSampleData(text: 'Wed', yValue: 26000),
            ChartSampleData(text: 'Thu', yValue: 19000),
            ChartSampleData(text: 'Fri', yValue: 28000),
            ChartSampleData(text: 'Sat', yValue: 32000),
          ],
          xValueMapper: (ChartSampleData data, _) => data.text,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: 'Visitors count',
          trendlines: <Trendline>[
            Trendline(
                type: _type,
                width: 3,
                color: const Color.fromRGBO(192, 108, 132, 1),
                dashArray: <double>[15, 3, 3, 3],
                polynomialOrder: _polynomialOrder,
                period: _period,
                onRenderDetailsUpdate: (TrendlineRenderParams args) {
                  _rSquare =
                      double.parse((args.rSquaredValue)!.toStringAsFixed(4))
                          .toString();
                  _slope = args.slope;
                  _intercept = args.intercept;
                  _getSlopeEquation(_slope, _intercept);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_displayRSquare! || _displaySlopeEquation!) {
                      setState(() {});
                    }
                  });
                })
          ])
    ];
  }

  void _getSlopeEquation(List<double>? slope, double? intercept) {
    if (_type == TrendlineType.linear) {
      _slopeEquation =
      'y = ${double.parse((slope![0]).toStringAsFixed(3))}x + ${double.parse(intercept!.toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.exponential) {
      _slopeEquation =
      'y = ${double.parse(intercept!.toStringAsFixed(3))}e^${double.parse((slope![0]).toStringAsFixed(3))}x';
    }
    if (_type == TrendlineType.logarithmic) {
      _slopeEquation =
      'y = ${double.parse(intercept!.toStringAsFixed(3))}ln(x) + ${double.parse((slope![0]).toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.polynomial) {
      if (_polynomialOrder == 2) {
        _slopeEquation =
        'y = ${double.parse((slope![1]).toStringAsFixed(3))}x +  ${double.parse((slope[0]).toStringAsFixed(3))}';
      }
      if (_polynomialOrder == 3) {
        _slopeEquation =
        'y = ${double.parse((slope![2]).toStringAsFixed(3))}x² + ${double.parse((slope[1]).toStringAsFixed(3))}x + ${double.parse((slope[0]).toStringAsFixed(3))}';
      }
      if (_polynomialOrder == 4) {
        _slopeEquation =
        'y = ${double.parse((slope![3]).toStringAsFixed(3))}x³ + ${double.parse((slope[2]).toStringAsFixed(3))}x²  + ${double.parse((slope[1]).toStringAsFixed(3))}x + ${double.parse((slope[0]).toStringAsFixed(3))}';
      }
    }
    if (_type == TrendlineType.power) {
      _slopeEquation =
      'y = ${double.parse(intercept!.toStringAsFixed(3))}x^${double.parse((slope![0]).toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.movingAverage) {
      _slopeEquation = '';
    }

    slopeTextSize =
        measureText(_slopeEquation, TextStyle(color: Colors.red));
  }

  Size measureText(String textValue, TextStyle textStyle, [int? angle]) {
    Size size;
    final TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        // textDirection: TextDirection.LTR ?? ,
        text: TextSpan(text: textValue, style: textStyle));
    textPainter.layout();

    if (angle != null) {
      // final Rect rect = rotatedTextSize(textPainter.size, angle);
      size = Size(250, 250);
    } else {
      size = Size(textPainter.width, textPainter.height);
    }
    return size;
  }


  void _onTrendLineTypeChanged(String item) {
    _selectedTrendLineType = item;
    switch (_selectedTrendLineType) {
      case 'linear':
        _type = TrendlineType.linear;
        break;
      case 'exponential':
        _type = TrendlineType.exponential;
        break;
      case 'power':
        _type = TrendlineType.power;
        break;
      case 'logarithmic':
        _type = TrendlineType.logarithmic;
        break;
      case 'polynomial':
        _type = TrendlineType.polynomial;
        break;
      case 'movingAverage':
        _type = TrendlineType.movingAverage;
        break;
    }
    setState(() {
      /// update the trend line  changes
    });
  }

  @override
  void initState() {
    _displayRSquare = false;
    _displaySlopeEquation = false;
    _rSquare = '';
    periodMaxValue = 0;
    _selectedTrendLineType = 'linear';
    _type = TrendlineType.linear;
    _polynomialOrder = 2;
    _period = 2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    isLegendTapped = false;
    _trendlineTypeList = <String>[
      'linear',
      'exponential',
      'power',
      'logarithmic',
      'polynomial',
      'movingAverage'
    ].toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customPaddedRowWidget( Text("PERFORMANCE",style: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.bold
        ),), 10),
        // MultiColoredChartForDashBoard(widget.currentMarks),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          // title: ChartTitle(
          //     text: isCardView ? '' : 'No. of website visitors in a week'),
          // legend: Legend(isVisible: !isCardView),
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              title: AxisTitle(text: ''),
              majorTickLines: const MajorTickLines(width: 0),
              numberFormat: NumberFormat.compact(),
              axisLine: const AxisLine(width: 0),
              interval: 10000,
              labelFormat: '{value}',
              maximum: 40000),
          series: _getTrendLineDefaultSeries(),
          onLegendTapped: (LegendTapArgs args) {
            setState(() {
              isLegendTapped = isLegendTapped == true ? false : true;
            });
          },
          tooltipBehavior: _tooltipBehavior,
          annotations: <CartesianChartAnnotation>[
            CartesianChartAnnotation(
                widget: SizedBox(
                    height: 90,
                    width: 170,
                    child: Visibility(
                      visible: !isLegendTapped,
                      child: Column(children: <Widget>[
                        // ignore: prefer_if_elements_to_conditional_expressions
                        (_displaySlopeEquation != null &&
                            _displaySlopeEquation! &&
                            _type != TrendlineType.movingAverage)
                            ? Text(
                          _slopeEquation,
                          style: TextStyle(color: Colors.red),
                          overflow: TextOverflow.ellipsis,
                        )
                            : const Text(''),
                        SizedBox(
                          height: 20,
                        ),
                        // ignore: prefer_if_elements_to_conditional_expressions
                        (_displayRSquare != null &&
                            _displayRSquare! &&
                            _type != TrendlineType.movingAverage)
                            ? Text('R² = ' + _rSquare,
                            style: TextStyle(color: Colors.red))
                            : const Text('')
                      ]),
                    )),
                coordinateUnit: CoordinateUnit.point,
                x: slopeTextSize != null && slopeTextSize!.width > 170
                    ? 'Wed'
                    : 'Thu',
                y: 34000),
          ],
        ),
        placeASizedBoxHere(20),
        BarChartForCCA(widget.activities),
        placeASizedBoxHere(20),
      ],
    );
  }
}

class StudentDashBoard_4 extends StatefulWidget {
  const StudentDashBoard_4({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard_4> createState() => _StudentDashBoard_4State();
}

class _StudentDashBoard_4State extends State<StudentDashBoard_4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customPaddedRowWidget( Text("LEARNING OUTCOMES",style: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.bold
        ),), 10),
        placeASizedBoxHere(10),
        customPaddedRowWidget(Text("Exam-Wise"), 10),
        placeASizedBoxHere(30),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LearningOutComes()));
            },
            child: customPaddedRowWidget(
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 100,
                  color: Colors.grey.shade400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Quarterly Examination")
                    ],
                  ),
                ),
              )
            , 5),
          );
        }, separatorBuilder: (BuildContext context, int index){
            return placeASizedBoxHere(20);
        }, itemCount: 1),
        placeASizedBoxHere(50)
      ],
    );
  }
}
