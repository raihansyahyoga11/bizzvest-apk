import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'bar_chart.dart';


class LineChart extends StatefulWidget {
  LineChart();
  @override
  _LineChartState createState() => _LineChartState();
}

Random random = Random();
class _LineChartState extends State<LineChart> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true, duration: 0.7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SfCartesianChart(

              primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
              primaryYAxis: NumericAxis(visibleMaximum: 100),
              enableAxisAnimation: true,
              backgroundColor: Color.fromRGBO(205, 245, 255, 1),

              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              tooltipBehavior: _tooltipBehavior,

              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  dataSource:  grossPercantage,
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  name: '% Gross margin over net sales',
                  color: Color.fromRGBO(142, 94, 162, 1),
                  markerSettings: MarkerSettings(isVisible: true, color: Color.fromRGBO(142, 94, 162, 1)),
                ),
                LineSeries<SalesData, String>(
                  dataSource: ebitdaPercantage,
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  name: '% EBITDA over net sales',
                  color: Color.fromRGBO(60, 186, 159, 1),
                  markerSettings: MarkerSettings(isVisible: true, color: Color.fromRGBO(60, 186, 159, 1)),
                ),
              ]
            )
          ],
        )
      ),
    );
  }
}
