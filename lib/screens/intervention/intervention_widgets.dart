import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// --- App Colors based on the image ---
class InterColors {
  static const Color creamBg = Color(0xFFF9F7F2);
  static const Color textDark = Color(0xFF264653);
  static const Color tealAccent = Color(0xFF2A9D8F);
  static const Color terraAccent = Color(0xFFE07A5F);
  static const Color greyLocked = Color(0xFF9E9E9E);
}

// --- WIDGET: The Future Wealth Chart Card ---
class FutureWealthChartCard extends StatelessWidget {
  final double currentAmount;
  // In future, calculate these based on currentAmount
  final double potentialValue = 48000; 
  
  const FutureWealthChartCard({super.key, required this.currentAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: InterColors.textDark.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Future Wealth Impact",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: InterColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                // The main chart
                LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 10000,
                      verticalInterval: 5,
                      getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                      getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 10000,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox();
                             // Simplified formatting for thousands
                            return Text('${(value/1000).toInt()}k', style: TextStyle(color: Colors.grey.shade400, fontSize: 10));
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const Text('2022', style: TextStyle(color: Colors.grey, fontSize: 10));
                            if (value == 20) return const Text('2042', style: TextStyle(color: Colors.grey, fontSize: 10));
                            return Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0, maxX: 20, minY: 0, maxY: 50000,
                    lineBarsData: [
                      // Investing Line (Green, curved upward)
                      LineChartBarData(
                        spots: [
                          FlSpot(0, currentAmount),
                          FlSpot(5, currentAmount * 1.5), // Dummy growth points
                          FlSpot(10, currentAmount * 2.5),
                          FlSpot(15, currentAmount * 5),
                          FlSpot(20, potentialValue),
                        ],
                        isCurved: true,
                        color: InterColors.tealAccent,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: InterColors.tealAccent.withOpacity(0.15)),
                      ),
                       // Spending Line (Red, flat/down)
                      LineChartBarData(
                        spots: [
                          FlSpot(0, currentAmount),
                          FlSpot(20, currentAmount * 0.8), // Slight depreciation
                        ],
                        isCurved: true,
                        color: InterColors.terraAccent.withOpacity(0.7),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                         belowBarData: BarAreaData(show: true, color: InterColors.terraAccent.withOpacity(0.05)),
                      ),
                    ],
                  ),
                ),
                // Overlays for Labels (Hardcoded positions based on dummy data for UI match)
                Positioned(
                  top: 10,
                  right: 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${potentialValue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ↓",
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: InterColors.tealAccent),
                      ),
                      Text("Potential Value Lost", style: GoogleFonts.poppins(fontSize: 12, color: InterColors.textDark)),
                    ],
                  ),
                ),
                Positioned(
                  top: 70, left: 20,
                  child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                  child: Text("Investing ₹${currentAmount.toInt()} (20 Yrs @ 12%)", style: GoogleFonts.poppins(fontSize: 10, color: InterColors.tealAccent, fontWeight: FontWeight.w600))),
                ),
                 Positioned(
                  bottom: 30, right: 50,
                  child: Text("Spending ₹${currentAmount.toInt()} Now", style: GoogleFonts.poppins(fontSize: 10, color: InterColors.terraAccent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET: Small Stat Card (e.g., Labor or Goal) ---
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  // Optional: to highlight the value part differently like in the image
  final String valueSuffix; 

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueSuffix = "",
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
           boxShadow: [
            BoxShadow(
              color: InterColors.textDark.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: InterColors.textDark, size: 28),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: InterColors.textDark),
                children: [
                  TextSpan(text: value),
                  TextSpan(text: " $valueSuffix", style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: The Pulsing Timer Ring ---
class TimerBrakeWidget extends StatelessWidget {
  final int secondsRemaining;
  final double progress; // 0.0 to 1.0

  const TimerBrakeWidget({super.key, required this.secondsRemaining, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Subtle outer pulsing ring
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: InterColors.tealAccent.withOpacity(0.1), width: 4),
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 1500.ms, curve: Curves.easeInOut),
        
        // The actual progress indicator
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: InterColors.tealAccent,
            strokeWidth: 6,
          ),
        ),
        // Center Text
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pause &\nReflect", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 10, color: InterColors.textDark)),
            Text("${secondsRemaining}s", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: InterColors.textDark)),
          ],
        )
      ],
    );
  }
}