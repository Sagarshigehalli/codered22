import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class RetirementProjectionCard extends StatelessWidget {
  const RetirementProjectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DashboardColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age & Retirement Projection', style: TextStyle(color: DashboardColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Info Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileTag(text: 'Age: 27'),
                  _ProfileTag(text: 'Profession: Software Engineer'),
                  _ProfileTag(text: 'Est. Annual Growth: 5%'),
                ],
              ),
              const SizedBox(width: 20),
              // Chart Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Retirement Fund Projection', style: TextStyle(color: DashboardColors.textDark, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if(value == 0) return Text('50');
                                  if(value == 2) return Text('55');
                                  if(value == 4) return Text('60');
                                  if(value == 6) return Text('65');
                                  return const SizedBox();
                                },
                                interval: 1,
                                reservedSize: 22
                              )
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                   if(value == 0) return Text('₹0');
                                   if(value == 1) return Text('₹1 Cr');
                                   if(value == 2) return Text('₹2 Cr');
                                   if(value == 3) return Text('₹3 Cr');
                                   if(value == 4) return Text('₹4 Cr');
                                   return const SizedBox();
                                },
                                interval: 1,
                                reservedSize: 40
                              )
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 1.2),
                                FlSpot(2, 2.1),
                                FlSpot(4, 3.5),
                                FlSpot(6, 4.8),
                              ],
                              isCurved: true,
                              color: DashboardColors.blueAccent,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: DashboardColors.blueAccent.withOpacity(0.2)
                              ),
                            ),
                          ],
                           lineTouchData: LineTouchData(
                             touchTooltipData: LineTouchTooltipData(
                               // tooltipBgColor: DashboardColors.blueAccent,
                               getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                 return touchedBarSpots.map((barSpot) {
                                   return LineTooltipItem(
                                     '₹${barSpot.y} Cr',
                                     const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                   );
                                 }).toList();
                               }),
                             enabled: true,
                             handleBuiltInTouches: true
                           )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  final String text;
  const _ProfileTag({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: DashboardColors.textDark, fontSize: 12)),
    );
  }
}