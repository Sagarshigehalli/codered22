import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// --- COLORS ---
class DashColors {
  static const Color background = Color(0xFFF4F7FE);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF1B2559);
  static const Color textGrey = Color(0xFFA3AED0);
  static const Color primary = Color(0xFF4318FF);
  static const Color green = Color(0xFF05CD99);
  static const Color orange = Color(0xFFFFB547);
  static const Color purple = Color(0xFF9747FF);
  static const Color red = Color(0xFFE31A1A);
  static const Color blue = Color(0xFF4318FF);
}

// --- WIDGETS ---

class SpendingDonutChart extends StatelessWidget {
  const SpendingDonutChart({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: DashColors.cardBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Spending Overview', style: TextStyle(color: DashColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                PieChart(PieChartData(
                  sectionsSpace: 0, centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(color: DashColors.green, value: 34, radius: 25, showTitle: false),
                    PieChartSectionData(color: DashColors.orange, value: 27, radius: 25, showTitle: false),
                    PieChartSectionData(color: DashColors.purple, value: 11, radius: 25, showTitle: false),
                    PieChartSectionData(color: DashColors.blue, value: 15, radius: 25, showTitle: false),
                    PieChartSectionData(color: DashColors.red, value: 4, radius: 25, showTitle: false),
                  ],
                )),
                const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text("Total:", style: TextStyle(color: DashColors.textGrey)), Text("₹36,500", style: TextStyle(color: DashColors.textDark, fontSize: 22, fontWeight: FontWeight.bold))])),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Wrap(spacing: 10, runSpacing: 10, children: [
            LegendItem(color: DashColors.green, label: "Groceries", val: "₹12,500"),
            LegendItem(color: DashColors.orange, label: "Hotels", val: "₹9,800"),
            LegendItem(color: DashColors.purple, label: "Fun", val: "₹4,200"),
            LegendItem(color: DashColors.red, label: "Others", val: "₹1,500"),
          ])
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color; final String label, val;
  const LegendItem({super.key, required this.color, required this.label, required this.val});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, color: color, size: 10), const SizedBox(width: 4),
      Text("$label ", style: const TextStyle(color: DashColors.textGrey, fontSize: 12)),
      Text(val, style: const TextStyle(color: DashColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
    ]);
  }
}

class SummaryStatCard extends StatelessWidget {
  final String title, value, trend; final bool isPositive;
  const SummaryStatCard({super.key, required this.title, required this.value, required this.trend, required this.isPositive});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: DashColors.cardBg, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: DashColors.textGrey, fontSize: 11)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: DashColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(children: [
            Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ? DashColors.green : DashColors.red, size: 14),
            Text(" $trend", style: TextStyle(color: isPositive ? DashColors.green : DashColors.red, fontSize: 12, fontWeight: FontWeight.bold))
          ])
        ]),
      ),
    );
  }
}

class RetirementCard extends StatelessWidget {
  const RetirementCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: DashColors.cardBg, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Retirement Projection', style: TextStyle(color: DashColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Chip(label: Text("Age: 27", style: TextStyle(fontSize: 10))),
            Chip(label: Text("Growth: 5%", style: TextStyle(fontSize: 10))),
          ]),
          Expanded(child: SizedBox(height: 100, child: LineChart(LineChartData(
            gridData: FlGridData(show: false), titlesData: FlTitlesData(show: false), borderData: FlBorderData(show: false),
            lineBarsData: [LineChartBarData(spots: const [FlSpot(0, 1), FlSpot(2, 2.5), FlSpot(4, 3.8), FlSpot(6, 4.8)], isCurved: true, color: DashColors.blue, barWidth: 3, dotData: FlDotData(show: true), belowBarData: BarAreaData(show: true, color: DashColors.blue.withOpacity(0.2)))]
          ))))
        ])
      ]),
    );
  }
}

class AiInsights extends StatelessWidget {
  const AiInsights({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE7F7FF), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.auto_awesome, color: DashColors.primary),
          const SizedBox(width: 8),
          const Text("AI Insights", style: TextStyle(fontWeight: FontWeight.bold, color: DashColors.textDark)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF9BE4FF), borderRadius: BorderRadius.circular(8)), child: const Text("AI Suggestion", style: TextStyle(fontSize: 10, color: DashColors.primary, fontWeight: FontWeight.bold)))
        ]),
        const SizedBox(height: 10),
        const Text("• Hotels & Dining is 20% above last month.", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 5),
        const Text("• Move ₹2,000 to retirement to save 3 years.", style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}

class ComparisonChart extends StatelessWidget {
  const ComparisonChart({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: DashColors.cardBg, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Month vs Month', style: TextStyle(color: DashColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(height: 150, child: BarChart(BarChartData(
          gridData: FlGridData(show: false), titlesData: FlTitlesData(show: false), borderData: FlBorderData(show: false),
          barGroups: [
            makeGroup(0, 12, 10), makeGroup(1, 9, 8), makeGroup(2, 5, 6), makeGroup(3, 4, 3)
          ]
        )))
      ]),
    );
  }
  BarChartGroupData makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y1, color: DashColors.blue, width: 8),
      BarChartRodData(toY: y2, color: Colors.grey[300], width: 8)
    ]);
  }
}