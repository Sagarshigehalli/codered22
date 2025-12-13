import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'dashboard_components.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data immediately when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    // Calculate trends (Simple logic: compare this month to last month)
    double spendDiff = userData.thisMonthSpend - userData.lastMonthSpend;
    String spendTrend = spendDiff > 0 
      ? "+${((spendDiff / (userData.lastMonthSpend == 0 ? 1 : userData.lastMonthSpend)) * 100).toStringAsFixed(1)}%" 
      : "${((spendDiff / (userData.lastMonthSpend == 0 ? 1 : userData.lastMonthSpend)) * 100).toStringAsFixed(1)}%";
    bool spendIncreased = spendDiff > 0;

    return Scaffold(
      backgroundColor: DashColors.background,
      body: SafeArea(
        child: userData.isLoadingDashboard 
          ? const Center(child: CircularProgressIndicator(color: DashColors.primary))
          : SingleChildScrollView(
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
                      child: const Text("Current Month ▼", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ]),
                  const SizedBox(height: 20),

                  // Spending Donut (Now Dynamic)
                  const SpendingDonutChart(),
                  const SizedBox(height: 20),

                  // Stats Cards Row 1 (Now Dynamic)
                  Row(children: [
                    SummaryStatCard(
                      title: "This Month", 
                      value: "₹${userData.thisMonthSpend.toStringAsFixed(0)}", 
                      trend: spendTrend, 
                      isPositive: !spendIncreased // Red if spent more
                    ),
                    const SizedBox(width: 12),
                    SummaryStatCard(
                      title: "Last Month", 
                      value: "₹${userData.lastMonthSpend.toStringAsFixed(0)}", 
                      trend: "Baseline", 
                      isPositive: true
                    ),
                  ]),
                  const SizedBox(height: 12),
                  
                  // Stats Cards Row 2 (Now Dynamic)
                  Row(children: [
                    SummaryStatCard(
                      title: "Savings Rate", 
                      value: "${userData.savingsRate.toStringAsFixed(1)}%", 
                      trend: userData.savingsRate > 20 ? "Healthy" : "Low", 
                      isPositive: userData.savingsRate > 20
                    ),
                    const SizedBox(width: 12),
                    SummaryStatCard(
                      title: "Debt Paid", 
                      value: "₹${userData.debtPaid.toStringAsFixed(0)}", 
                      trend: "On Track", 
                      isPositive: true
                    ),
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

                  // Right Column Content (Still Static/Dummy as per request)
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