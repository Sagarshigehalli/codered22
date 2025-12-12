import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class SummaryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trendValue;
  final bool isTrendPositive;

  const SummaryStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trendValue,
    this.isTrendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DashboardColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: DashboardColors.textGrey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: DashboardColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isTrendPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isTrendPositive ? DashboardColors.greenAccent : DashboardColors.redAccent,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  trendValue,
                  style: TextStyle(
                    color: isTrendPositive ? DashboardColors.greenAccent : DashboardColors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
             // Add miniature LineChart here if needed, omitted for brevity but follows similar pattern to main chart
          ],
        ),
      ),
    );
  }
}