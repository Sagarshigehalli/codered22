import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class DebtPayoffWidget extends StatelessWidget {
  const DebtPayoffWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
        color: DashboardColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('Debt Payoff Timeline', style: TextStyle(color: DashboardColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
             Text('Current Outstanding Debt: ₹4.5 Lakh', style: TextStyle(color: DashboardColors.textDark, fontWeight: FontWeight.w600)),
             Text('Target: 10 Months', style: TextStyle(color: DashboardColors.textDark)),
           ]),
           const SizedBox(height: 12),
           // Standard Timeline
           Column(
             children: [
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("Start", style: TextStyle(fontSize: 10)), Text("Expected: 9 Months  On track", style: TextStyle(fontSize: 10, color: DashboardColors.greenAccent))]),
               const SizedBox(height: 4),
               ClipRRect(
                 borderRadius: BorderRadius.circular(10),
                 child: LinearProgressIndicator(
                   value: 0.8, // Dummy progress
                   backgroundColor: Colors.grey.shade200,
                   color: DashboardColors.blueAccent,
                   minHeight: 8,
                 ),
               ),
             ],
           ),
           const SizedBox(height: 16),
           // AI Suggestion Timeline
            Column(
             children: [
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("With AI Suggestion: 7 Months", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), SizedBox()]),
               const SizedBox(height: 4),
               Stack(
                 children: [
                    ClipRRect(
                     borderRadius: BorderRadius.circular(10),
                     child: const LinearProgressIndicator(
                       value: 1.0,
                       backgroundColor: Colors.white,
                       color: DashboardColors.greenAccent,
                       minHeight: 8,
                     ),
                   ),
                    // The "Potential Saving" marker part
                    Positioned(
                      right: 0,
                      left: 250, // Adjust based on progress
                      child: Container(height: 8, decoration: BoxDecoration(color: DashboardColors.greenAccent.withOpacity(0.3), borderRadius: BorderRadius.circular(10)))
                    )
                 ],
               ),
                const SizedBox(height: 4),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("Start", style: TextStyle(fontSize: 10)), Text("Potential Saving: 2 Months", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
             ],
           ),

        ],
      ),
    );
  }
}