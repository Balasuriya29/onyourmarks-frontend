import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'functional.dart';

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
        series: getDefaultDoughnutSeries(widget.marks),
        tooltipBehavior:TooltipBehavior(enable: true, format: 'point.x : point.y%'),
      ),
    );
  }
}

class MultiColoredChartForDashBoard extends StatefulWidget {
  final currentMarks;
  const MultiColoredChartForDashBoard(this.currentMarks, {Key? key}) : super(key: key);
  @override
  State<MultiColoredChartForDashBoard> createState() => _MultiColoredChartForDashBoardState();
}

class _MultiColoredChartForDashBoardState extends State<MultiColoredChartForDashBoard> {
  @override
  Widget build(BuildContext context) {
    return customPaddedRowWidget(SfCartesianChart(
      title: ChartTitle(text: 'Academics'),
      plotAreaBorderWidth: 0,
      legend: Legend(),
      primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
              overflow: TextOverflow.ellipsis
          ),
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(text: 'Subjects')),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 10,
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: getMultiColoredLineSeries(widget.currentMarks.values.first, context),
      trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y')),
    ), 10);
  }
}

class BarChartForCCA extends StatefulWidget {
  final models;
  BarChartForCCA(this.models,{Key? key}) : super(key: key);

  @override
  _BarChartForCCAState createState() => _BarChartForCCAState();
}

class _BarChartForCCAState extends State<BarChartForCCA> {
  @override
  Widget build(BuildContext context) {
    return customPaddedRowWidget(
        SfCartesianChart(
            title: ChartTitle(text: "CCA Status"),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 10, interval: 1),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<ChartDataForCCA, String>>[
              ColumnSeries<ChartDataForCCA, String>(
                  dataSource: getChartDataForCCA(widget.models),
                  xValueMapper: (ChartDataForCCA data, _) => data.x,
                  yValueMapper: (ChartDataForCCA data, _) => data.y,
                  name: 'Gold',
                  color: Color.fromRGBO(8, 142, 255, 1))
            ]
        ), 10);
  }
}

class ColumnChartForSubjectMarks extends StatefulWidget {
  final currentMarks;
  const ColumnChartForSubjectMarks(this.currentMarks,{Key? key}) : super(key: key);

  @override
  State<ColumnChartForSubjectMarks> createState() => _ColumnChartForSubjectMarksState();
}

class _ColumnChartForSubjectMarksState extends State<ColumnChartForSubjectMarks> {
  @override
  Widget build(BuildContext context) {
    return customPaddedRowWidget
      (
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          title: ChartTitle(text: "Current Exam Marks"),
          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            axisLine: const AxisLine(width: 0),
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: getTracker(widget.currentMarks.values.first, context),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: false,
              header: '',
              format: 'point.y marks in point.x'),
        )
      ,10);
  }
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

class ChartData {
  ChartData(this.x, this.y, [this.lineColor]);
  final String x;
  final double y;
  final Color? lineColor;
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class ChartDataForCCA {
  ChartDataForCCA(this.x, this.y);

  final String x;
  final double y;
}
