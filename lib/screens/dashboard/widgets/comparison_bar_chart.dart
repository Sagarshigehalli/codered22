import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class ComparisonBarChart extends StatelessWidget {
  const ComparisonBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the chart
    final List<double> thisMonthData = [12.5, 9.8, 5.4, 4.2, 3.1];
    final List<double> lastMonthData = [11.0, 8.0, 6.0, 3.8, 2.5];
    final List<String> labels = ['Groceries', 'Hotels', 'Travel', 'Fun', 'Utilities'];

    return Container(
      padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
        color: DashboardColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('Month-to-Month Comparison', style: TextStyle(color: DashboardColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(labels[value.toInt()], style: TextStyle(color: DashboardColors.textGrey, fontSize: 10)),
                        );
                      },
                      reservedSize: 30
                    )
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(thisMonthData.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(toY: thisMonthData[index], color: DashboardColors.blueAccent, width: 12, borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: lastMonthData[index], color: DashboardColors.textGrey.withOpacity(0.5), width: 12, borderRadius: BorderRadius.circular(4)),
                    ],
                  );
                }),
              ),
            ),
          ),
           // Trend Labels above bars (Simplified dummy representation)
           Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
             Text('+2%', style: TextStyle(color: DashboardColors.greenAccent, fontSize: 10)),
             Text('+20%', style: TextStyle(color: DashboardColors.redAccent, fontSize: 10)),
             Text('-5%', style: TextStyle(color: DashboardColors.greenAccent, fontSize: 10)),
             Text('+4%', style: TextStyle(color: DashboardColors.redAccent, fontSize: 10)),
             Text('+3%', style: TextStyle(color: DashboardColors.redAccent, fontSize: 10)),
           ]),
            const SizedBox(height: 10),
           // Legend
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.square, color: DashboardColors.blueAccent, size: 12),
               const SizedBox(width: 4),
               Text("This Month (Dec '25)", style: TextStyle(color: DashboardColors.textGrey, fontSize: 12)),
               const SizedBox(width: 16),
               Icon(Icons.square, color: DashboardColors.textGrey.withOpacity(0.5), size: 12),
               const SizedBox(width: 4),
               Text("Last Month (Nov '25)", style: TextStyle(color: DashboardColors.textGrey, fontSize: 12)),
             ],
           )
        ],
      ),
    );
  }
}