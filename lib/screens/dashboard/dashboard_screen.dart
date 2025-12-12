import 'package:flutter/material.dart';
import 'dashboard_components.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DashColors.textDark)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text("Dec 2025 ▼", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ]),
              const SizedBox(height: 20),

              // Spending Donut
              const SpendingDonutChart(),
              const SizedBox(height: 20),

              // Stats Cards Row 1
              const Row(children: [
                SummaryStatCard(title: "This Month", value: "₹36,500", trend: "+8%", isPositive: false),
                SizedBox(width: 12),
                SummaryStatCard(title: "Last Month", value: "₹33,800", trend: "+2%", isPositive: false),
              ]),
              const SizedBox(height: 12),
              // Stats Cards Row 2
              const Row(children: [
                SummaryStatCard(title: "Savings Rate", value: "18%", trend: "+1.5%", isPositive: true),
                SizedBox(width: 12),
                SummaryStatCard(title: "Debt Paid", value: "₹15k", trend: "On Track", isPositive: true),
              ]),
              const SizedBox(height: 20),

              // Actions
              const Text("Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DashColors.textDark)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _actionBtn(Icons.tune, "Goals"),
                _actionBtn(Icons.receipt_long, "Txns"),
                _actionBtn(Icons.download, "Report"),
                _actionBtn(Icons.savings, "Retire"),
              ]),
              const SizedBox(height: 20),

              // Right Column Content (Retirement, AI, Comparison)
              const RetirementCard(),
              const SizedBox(height: 20),
              const AiInsights(),
              const SizedBox(height: 20),
              const ComparisonChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: DashColors.textDark),
      ),
      const SizedBox(height: 5),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))
    ]);
  }
}