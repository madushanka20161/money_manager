import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:provider/provider.dart';

class LineChart01 extends StatefulWidget {
  final String selectedTab;
  final List<TransactionDto> income;
  final List<TransactionDto> expenses;

  const LineChart01({
    super.key, 
    required this.selectedTab,
    required this.income,
    required this.expenses
  });

  @override
  State<LineChart01> createState() => _LineChart01State();
}

class _LineChart01State extends State<LineChart01> {
  List<Color> gradientColors = [
    Colors.red,
    Colors.greenAccent,
  ];
  late DateTime startDate;
  late DateTime endDate;
  late String timePeriod;
  Map<int, double> dataArray = {};
  double total = 0;

  void calculateData() {
    List<TransactionDto> collection = (widget.selectedTab == TransactionType.income.displayName) ? widget.income : widget.expenses;
    
    total = 0;
    for (var transaction in collection) {
      dataArray[transaction.date.day] = total + transaction.amount;
      total = dataArray[transaction.date.day]!;
      print(transaction.date.day);
    }

    dataArray.forEach((key, value) {
      print('Day: $key, Amount: $value');
    });
  }

  @override
  void initState() {
    super.initState();
    calculateData();
  }

  @override
  void didUpdateWidget(LineChart01 oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('----------111111222222, ${widget.selectedTab}');
    calculateData();
  }

  @override
  Widget build(BuildContext context) {
    startDate = context.watch<AppState>().startDate;
    endDate = context.watch<AppState>().endDate;
    timePeriod = context.watch<UserState>().defaultTimePeriod!;

    print('------------0000000000000000000, ${widget.selectedTab}');
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       'avg',
        //       style: TextStyle(
        //         fontSize: 12,
        //         color: showAvg
        //             ? Colors.white.withValues(alpha: 0.5)
        //             : Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    print('++++++, $value , $meta');
    switch (value.toInt()) {
      case 5:
        text = const Text('05', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 25:
        text = const Text('25', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    print('-----, $value , $meta');
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.amber,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d)),
      // ),
      minX: 0,
      // maxX: 11,
      minY: 0,
      // maxY: 6,
      lineBarsData: [
        LineChartBarData(
          // spots: dataArray.entries.map((entry) {
          //   return FlSpot(entry.key.toDouble(), entry.value);
          // }).toList(),
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 5),
            FlSpot(4, 6),
            FlSpot(5, 7),
            FlSpot(6, 2),
          ],
          // isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}