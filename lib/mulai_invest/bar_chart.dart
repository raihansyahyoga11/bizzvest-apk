import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

List<SalesData> grossPercantage = [];
List<SalesData> ebitdaPercantage = [];

class BarChart extends StatefulWidget {
  BarChart();
  @override
  _BarChartState createState() => _BarChartState();
}

Random random = Random();
class _BarChartState extends State<BarChart> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true, duration: 0.7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var netSales = [];
    var grossMargin = [];
    var ebitda = [];
    var month = List.filled(20, '');
    grossPercantage = [];
    ebitdaPercantage = [];
    month[0] = "Januari";
    month[1] = "Februari";
    month[2] = "Maret";
    month[3] = "April";
    month[4] = "Mei";
    month[5] = "Juni";
    month[6] = "Juli";
    month[7] = "Agustus";
    month[8] = "September";
    month[9] = "Oktober";
    month[10] = "November";
    month[11] = "Desember";

    var now = DateTime.now();
    for (int i = 0; i<6; i++){
      netSales.add(random.nextDouble()*70 + 5 + random.nextInt(20).toDouble());
      grossMargin.add(netSales[i]/(random.nextDouble()*1+1.8));
      ebitda.add(grossMargin[i]/(random.nextDouble()*1+1.5));
    }
    List<ChartData> chartData = [];
    
    int temp = 7;
    for (int i = 0; i<6; i++){
      chartData.add(ChartData(month[now.month-temp], netSales[i], grossMargin[i], ebitda[i]));
      grossPercantage.add(SalesData(month[now.month-temp], grossMargin[i]*100/netSales[i]));
      ebitdaPercantage.add(SalesData(month[now.month-temp], ebitda[i]*100/netSales[i]));
      temp--;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(205, 245, 255, 1),
              height: 50,
            ),
            SfCartesianChart(
              backgroundColor: Color.fromRGBO(205, 245, 255, 1),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Nominal (dalam satuan juta)',
                  textStyle: TextStyle(fontSize: 10.5)
                )
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              tooltipBehavior: _tooltipBehavior,
              title: ChartTitle(
                text: 'Grafik Keuangan',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )
              ),

              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: 'Net Sales',
                    color: Color.fromRGBO(69, 138, 247, 1),
                    spacing: 0.1,
                ),
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y1,
                    name: 'Gross Margin',
                    color: Color.fromRGBO(142, 94, 162, 1),
                    spacing: 0.1,
                ),
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y2,
                    name: 'EBITDA',
                    color: Color.fromRGBO(60, 186, 159, 1),
                    spacing: 0.1,
                )
              ]
            )
          ],
        )
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
}
