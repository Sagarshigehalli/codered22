import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final themeColor = const Color(0xFF264653); // Slate
    final accentColor = const Color(0xFFE07A5F); // Terracotta

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: themeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Report Card", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. HEADER: Avatar & Grade
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: accentColor, width: 3)),
                        child: const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Text("A+", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Keerth", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: themeColor)),
                  Text(userData.financialGrade, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. STREAK STATS GRID
            Row(
              children: [
                _buildStatCard("Current Streak", "${userData.currentStreak} Days", Icons.local_fire_department, Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard("Saved in Streak", "₹${userData.totalSavedInStreak.toStringAsFixed(0)}", Icons.savings, Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard("Best Streak", "${userData.maxStreak} Days", Icons.emoji_events, Colors.amber),
                const SizedBox(width: 16),
                _buildStatCard("Total Savings", "₹${(userData.totalLifetimeSavings/1000).toStringAsFixed(1)}k", Icons.account_balance_wallet, themeColor),
              ],
            ),

            const SizedBox(height: 30),

            // 3. MONTHLY SAVINGS GRAPH
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Monthly Savings History", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: themeColor)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                int index = val.toInt();
                                if(index >= 0 && index < userData.monthlySavingsHistory.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(userData.monthlySavingsHistory[index]['month'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  );
                                }
                                return const SizedBox();
                              },
                            )
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: userData.monthlySavingsHistory.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value['amount'],
                                color: e.key == userData.monthlySavingsHistory.length - 1 ? accentColor : themeColor.withOpacity(0.3),
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            Text(value, style: TextStyle(color: const Color(0xFF264653), fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}