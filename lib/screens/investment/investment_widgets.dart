import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Colors for Investment Theme ---
class InvestColors {
  static const Color creamBg = Color(0xFFF9F7F2);
  static const Color darkSlate = Color(0xFF264653);
  static const Color greenStart = Color(0xFF2A9D8F); // Teal
  static const Color greenEnd = Color(0xFF4CBFA6);   // Lighter Green
  static const Color textWhite = Colors.white;
  static const Color lowRisk = Color(0xFFE5F9F6);    // Light Green bg
  static const Color medRisk = Color(0xFFFFF4E5);    // Light Orange bg
}

// --- WIDGET: Header with Avatar & Bubble ---
class InvestmentHeader extends StatelessWidget {
  const InvestmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text("Maa", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: InvestColors.darkSlate)),
                ),
                const SizedBox(width: 8),
                Text("Investment Overview", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: InvestColors.darkSlate)),
              ],
            ),
            const Icon(Icons.refresh, color: InvestColors.darkSlate),
          ],
        ),
        const SizedBox(height: 20),
        // Speech Bubble
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD8EFEA), // Very light teal
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Friendly advisor avatar
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Small steps lead to big gains! Investing your saved impulses grows your future.",
                  style: GoogleFonts.poppins(fontSize: 12, color: InvestColors.darkSlate),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- WIDGET: Impulse Savings Card (Green Gradient + Donut) ---
class ImpulseSavingsCard extends StatelessWidget {
  const ImpulseSavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [InvestColors.greenStart, InvestColors.greenEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: InvestColors.greenStart.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          // Left Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invested from impulses", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text("12 impulses invested this month", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(height: 16),
                Text("₹12,500", style: GoogleFonts.poppins(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                Text("This month's invested savings", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
          // Right Circular Chart
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    startDegreeOffset: 270,
                    sections: [
                      PieChartSectionData(color: Colors.white, value: 65, radius: 8, showTitle: false),
                      PieChartSectionData(color: Colors.white.withOpacity(0.2), value: 35, radius: 8, showTitle: false),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("65%", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("of goal", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- WIDGET: Primary Goal Card (Linear Progress) ---
class PrimaryGoalCard extends StatelessWidget {
  const PrimaryGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Slightly lighter gradient
        gradient: LinearGradient(
          colors: [InvestColors.greenStart.withOpacity(0.8), InvestColors.greenEnd.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Primary Goal", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text("First House", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Target: ₹50,00,000\nCurrent: ₹12,45,000", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text("On track by Aug 2026", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(4))),
              Container(height: 8, width: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
            ],
          ),
          const SizedBox(height: 4),
          Text("25%", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}

// --- WIDGET: Small Option Card (Index Fund etc) ---
class InvestmentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String risk;
  final Color riskColor; // Dot color

  const InvestmentOptionCard({super.key, required this.icon, required this.title, required this.risk, required this.riskColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: InvestColors.darkSlate, size: 20),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: InvestColors.darkSlate)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: riskColor == Colors.green ? InvestColors.lowRisk : InvestColors.medRisk,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(risk, style: GoogleFonts.poppins(fontSize: 10, color: Colors.black87)),
                  const SizedBox(width: 4),
                  Icon(Icons.circle, size: 6, color: riskColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: Auto Invest Toggle ---
class AutoInvestTile extends StatefulWidget {
  const AutoInvestTile({super.key});

  @override
  State<AutoInvestTile> createState() => _AutoInvestTileState();
}

class _AutoInvestTileState extends State<AutoInvestTile> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Auto-invest cancelled impulses", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: InvestColors.darkSlate)),
              Switch(
                value: isSwitched,
                onChanged: (val) => setState(() => isSwitched = val),
                activeColor: Colors.white,
                activeTrackColor: InvestColors.greenStart,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Any cancelled impulse above ₹500 moves straight into your investments",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}