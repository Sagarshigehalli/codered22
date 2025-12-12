import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'intervention_widgets.dart';
// Ensure this path is correct based on your folder structure
import '../investment/investment_page.dart';

class InterventionScreen extends StatefulWidget {
  final double transactionAmount;

  const InterventionScreen({super.key, required this.transactionAmount});

  @override
  State<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> with TickerProviderStateMixin {
  // FIXED: Correct variable name without spaces
  static const int _kTimerDurationSeconds = 25;
  
  int _secondsRemaining = _kTimerDurationSeconds;
  late Timer _timer;
  late AnimationController _progressController;
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _kTimerDurationSeconds),
    );
    _progressController.reverse(from: 1.0); // Start full and go down

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isLocked = false;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InterColors.creamBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: InterColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replace with your actual asset logo if you have one
            Icon(Icons.spa, color: InterColors.textDark, size: 20), 
            const SizedBox(width: 8),
            Text(
              "Transaction Insight",
              style: GoogleFonts.poppins(color: InterColors.textDark, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 1. The Main Chart Card
                    FutureWealthChartCard(currentAmount: widget.transactionAmount),
                    
                    const SizedBox(height: 20),
                    
                    // 2. The Row of Stat Cards
                    // NOTE: These values are dummy for now. 
                    // In future, calculate them based on widget.transactionAmount and user profile data.
                    Row(
                      children: const [
                        StatCard(
                          icon: Icons.access_time_filled,
                          title: "Work Hours Burned",
                          value: "4.5",
                          valueSuffix: "Hrs",
                        ),
                        SizedBox(width: 16),
                        StatCard(
                          icon: Icons.two_wheeler,
                          title: "Superbike Goal Delayed",
                          value: "+18",
                          valueSuffix: "Days",
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 3. The Timer Brake
                     AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return TimerBrakeWidget(
                          secondsRemaining: _secondsRemaining,
                          // Calculate progress for the circle indicator
                          progress: _secondsRemaining / _kTimerDurationSeconds,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 4. Bottom Action Area (Fixed at bottom)
            Container(
              padding: const EdgeInsets.all(24),
              // Define specific rounded top corners for the bottom sheet area
              decoration: const BoxDecoration(
                color: InterColors.creamBg,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary Positive Action
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Investment Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InvestmentPage()),
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Redirecting to Investment...")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: InterColors.tealAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Invest This ₹${widget.transactionAmount.toInt()} Instead",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Secondary Locked Action
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLocked ? null : () {
                         // TODO: Proceed with actual payment
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing Payment...")));
                         Navigator.pop(context); // Close intervention
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLocked ? InterColors.greyLocked : InterColors.textDark,
                        disabledBackgroundColor: InterColors.greyLocked,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                      icon: Icon(_isLocked ? Icons.lock : Icons.lock_open, color: Colors.white70),
                      label: Text(
                        _isLocked ? "Pay Now (Locked)" : "Pay Now (Unlocked)",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Emergency Override Link
                  TextButton(
                    onPressed: () {
                       // TODO:Handle emergency override (maybe with a confirmation dialog)
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency Override Activated")));
                       Navigator.pop(context);
                    },
                    child: Text(
                      "Emergency One-Time Override",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: InterColors.textDark.withOpacity(0.6),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}