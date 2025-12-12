import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';

class StatisticsRevealPage extends StatefulWidget {
  const StatisticsRevealPage({super.key});
  @override
  State<StatisticsRevealPage> createState() => _StatisticsRevealPageState();
}

class _StatisticsRevealPageState extends State<StatisticsRevealPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserDataProvider>(context);
    double expenseRatio = data.totalBalance > 0 ? (data.lockedAmount / data.totalBalance * 100) : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Maa's Report Card", style: TextStyle(color: Colors.white54, letterSpacing: 1.5, fontSize: 14)),
              const SizedBox(height: 8),
              const Text("The Reality Check", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _buildStatRow(icon: Icons.timer, color: Colors.amber, label: "YOUR VALUE", value: "₹${data.earningsPerMinute.toStringAsFixed(2)} / min", desc: "Don't waste a minute worth ₹${data.earningsPerMinute.toStringAsFixed(0)} on scrolling."),
              const SizedBox(height: 24),
              _buildStatRow(icon: Icons.trending_up, color: const Color(0xFF2A9D8F), label: "WEALTH RANK", value: data.indiaWealthRank, desc: "You earn better than most. Be grateful and save it."),
              const SizedBox(height: 24),
              _buildStatRow(icon: Icons.pie_chart, color: data.financialHealthStatus == "Healthy" ? Colors.green : const Color(0xFFE07A5F), label: "SPENDING HEALTH", value: "${expenseRatio.toStringAsFixed(0)}% on Bills", desc: data.financialHealthMessage),
              const Spacer(),
              SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF264653), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => Provider.of<AuthProvider>(context, listen: false).completeOnboarding(), child: const Text("Enter Dashboard", style: TextStyle(fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({required IconData icon, required Color color, required String label, required String value, required String desc}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4))]))]).animate().fadeIn().slideX();
  }
}