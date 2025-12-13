import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/user_provider.dart';

class StudentExpenseStatisticsPage extends StatelessWidget {
  final VoidCallback onNext;
  const StudentExpenseStatisticsPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserDataProvider>(context);
    final frequent = data.frequentDestinations;
    final distribution = data.expenseDistribution;
    // Updated to use the top 3 variable we created
    final top3 = data.top3HighestSpends; 

    // Professional Palette
    final List<Color> chartColors = [
      const Color(0xFF2A9D8F), // Teal
      const Color(0xFFE07A5F), // Terracotta
      const Color(0xFF264653), // Dark Slate
      const Color(0xFFE9C46A), // Mustard
      const Color(0xFFF4A261), // Orange
      Colors.grey.shade400,    // Others
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        title: Text("Analysis Report", style: GoogleFonts.poppins(color: const Color(0xFF264653), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF264653)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- SECTION 1: FREQUENCY ---
            _buildSectionHeader("Frequent Spots", "Where you visit the most"),
            const SizedBox(height: 16),
            
            frequent.isEmpty
                ? const Center(child: Text("No data yet.", style: TextStyle(color: Colors.grey)))
                : SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: frequent.length,
                      separatorBuilder: (c, i) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        String key = frequent.keys.elementAt(index);
                        double val = frequent.values.elementAt(index);
                        return Container(
                          width: 150,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black.withOpacity(0.05)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(key, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF264653))),
                              const SizedBox(height: 6),
                              Text("₹${val.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 22, color: const Color(0xFFE07A5F), fontWeight: FontWeight.bold)),
                              Text("avg / visit", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 32),

            // --- SECTION 2: DISTRIBUTION (Clean Chart) ---
            _buildSectionHeader("Spending Distribution", "Category breakdown"),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: distribution.isEmpty
                  ? const Center(child: Text("Insufficient Data"))
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 50,
                              startDegreeOffset: -90,
                              sections: distribution.entries.toList().asMap().entries.map((entry) {
                                int idx = entry.key;
                                var dataEntry = entry.value;
                                return PieChartSectionData(
                                  color: chartColors[idx % chartColors.length],
                                  value: dataEntry.value,
                                  showTitle: false, // Clean look: No text on chart
                                  radius: 25,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Professional Legend
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: distribution.entries.toList().asMap().entries.map((entry) {
                            int idx = entry.key;
                            var dataEntry = entry.value;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: chartColors[idx % chartColors.length], shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text(
                                  "${dataEntry.key} (${(dataEntry.value / data.detectedMonthlyExpense * 100).toStringAsFixed(0)}%)",
                                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF264653)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 32),

            // --- SECTION 3: TOP 3 SPENDS ---
            _buildSectionHeader("Top 3 Expenses", "Highest single transactions"),
            const SizedBox(height: 16),
            ...top3.map((tx) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.03)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E5), // Light Orange
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.trending_up, color: Color(0xFFE07A5F), size: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx['merchant'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF264653))),
                          Text(tx['time'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      "- ₹${tx['numericAmount'].toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFFE07A5F)),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF264653),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("Generate Final Profile", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF264653))),
        Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}