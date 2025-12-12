import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class SpendingDonutChart extends StatelessWidget {
  const SpendingDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending Overview',
          style: TextStyle(
            color: DashboardColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 70,
                  sections: [
                    // Dummy Data mirroring the image
                    PieChartSectionData(color: DashboardColors.greenAccent, value: 34, title: '34%', radius: 25, showTitle: false),
                    PieChartSectionData(color: DashboardColors.orangeAccent, value: 27, title: '27%', radius: 25, showTitle: false),
                    PieChartSectionData(color: DashboardColors.purpleAccent, value: 11, title: '11%', radius: 25, showTitle: false),
                    PieChartSectionData(color: DashboardColors.blueAccent, value: 15, title: '15%', radius: 25, showTitle: false),
                     PieChartSectionData(color: DashboardColors.greenAccent.withOpacity(0.5), value: 8, title: '8%', radius: 25, showTitle: false),
                     PieChartSectionData(color: DashboardColors.redAccent, value: 4, title: '4%', radius: 25, showTitle: false),
                  ],
                ),
              ),
              // Center Text
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total:', style: TextStyle(color: DashboardColors.textGrey, fontSize: 14)),
                    Text(
                      '₹36,500',
                      style: TextStyle(
                        color: DashboardColors.textDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              // Floating Labels (Simplified for this example, ideally positioned dynamically)
              const Positioned(top: 0, right: 0, child: _ChartLabel(color: DashboardColors.greenAccent, label: "Groceries\n₹12,500")),
              const Positioned(bottom: 20, right: 0, child: _ChartLabel(color: DashboardColors.orangeAccent, label: "Hotels & Dining\n₹9,800")),
              // Add other labels similarly based on exact positions desired
            ],
          ),
        ),
         const SizedBox(height: 20),
         // Legend at bottom
         Wrap(
           spacing: 10,
           runSpacing: 10,
           children: [
             _LegendItem(color: DashboardColors.greenAccent, label: "Groceries", value: "₹12,500"),
             _LegendItem(color: DashboardColors.orangeAccent, label: "Hotels & Dining", value: "₹9,800"),
             _LegendItem(color: DashboardColors.purpleAccent, label: "Entertainment", value: "₹4,200"),
             // Add others...
           ],
         )
      ],
    );
  }
}

class _ChartLabel extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLabel({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, color: color, size: 10), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12))]);
  }
}

class _LegendItem extends StatelessWidget {
   final Color color;
   final String label;
   final String value;
   const _LegendItem({required this.color, required this.label, required this.value});
   @override
   Widget build(BuildContext context) {
     return Row(
       mainAxisSize: MainAxisSize.min,
       children: [
         Icon(Icons.circle, color: color, size: 12),
         const SizedBox(width: 6),
         Text("$label ", style: TextStyle(color: DashboardColors.textGrey, fontSize: 12)),
         Text(value, style: TextStyle(color: DashboardColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
       ],
     );
   }
}