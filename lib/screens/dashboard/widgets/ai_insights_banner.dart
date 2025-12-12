import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class AiInsightsBanner extends StatelessWidget {
  const AiInsightsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DashboardColors.aiBannerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: DashboardColors.primaryBrand),
              const SizedBox(width: 8),
              Text('Smart Insights & AI Suggestions', style: TextStyle(color: DashboardColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: DashboardColors.aiButtonBg, borderRadius: BorderRadius.circular(12)),
                child: Row(children: const [Icon(Icons.android, size: 16, color: DashboardColors.primaryBrand), SizedBox(width: 4), Text('AI Suggestion', style: TextStyle(fontSize: 12, color: DashboardColors.primaryBrand, fontWeight: FontWeight.w600))]),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Icon(Icons.auto_awesome_mosaic, color: DashboardColors.blueAccent, size: 30),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   children: const [
                     _InsightItem(text: 'Spending on Hotels & Dining is 20% above last month. Consider cooking more at home.'),
                     _InsightItem(text: 'Your grocery expenses have remained stable, showing good budgeting.'),
                     _InsightItem(text: 'Move ₹2,000 from fun expenses to your retirement goal to retire 3 years earlier and save more.'),
                   ],
                 ),
               )
            ],
          )
        ],
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final String text;
  const _InsightItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right_alt, color: DashboardColors.blueAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: DashboardColors.textDark, fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}