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

  @override
  void initState() {

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

class MultiColoredChartForDashBoard extends StatefulWidget {
  final currentMarks;
  const MultiColoredChartForDashBoard(this.currentMarks, {Key? key}) : super(key: key);
  @override
  State<MultiColoredChartForDashBoard> createState() => _MultiColoredChartForDashBoardState();
}

class _MultiColoredChartForDashBoardState extends State<MultiColoredChartForDashBoard> {
  TrackballBehavior? _trackballBehavior;
  @override
  void initState(){
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return customPaddedRowWidget(Container(
        child: SfCartesianChart(
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
          trackballBehavior: _trackballBehavior,
        )
    ), 10);
  }
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
