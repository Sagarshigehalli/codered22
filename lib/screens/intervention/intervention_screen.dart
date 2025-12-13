import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'intervention_widgets.dart';
import '../investment/investment_page.dart';

class InterventionScreen extends StatefulWidget {
  final double transactionAmount;

  const InterventionScreen({super.key, required this.transactionAmount});

  @override
  State<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> with TickerProviderStateMixin {
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
    _progressController.reverse(from: 1.0); 

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _isLocked = false;
            _timer.cancel();
          }
        });
      }
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
    final userData = Provider.of<UserDataProvider>(context);

    // --- DYNAMIC CALCULATION LOGIC ---
    String stat1Title;
    String stat1Value;
    String stat1Suffix;
    IconData stat1Icon;

    if (userData.earningsPerMinute > 0) {
      // SALARIED: Calculate actual work hours
      // Cost / (Earnings/min * 60)
      double hours = widget.transactionAmount / (userData.earningsPerMinute * 60);
      stat1Title = "Work Hours Burned";
      stat1Value = hours.toStringAsFixed(1);
      stat1Suffix = "Hrs";
      stat1Icon = Icons.access_time_filled;
    } else {
      // STUDENT: Calculate days of pocket money lost
      // (Cost / Total Monthly) * 30 days
      double totalIncome = userData.totalBalance + userData.lockedAmount; // Approx monthly
      if (totalIncome == 0) totalIncome = 1; // Prevent div by zero
      double days = (widget.transactionAmount / totalIncome) * 30;
      
      stat1Title = "Allowance Wipeout";
      stat1Value = days.toStringAsFixed(1);
      stat1Suffix = "Days";
      stat1Icon = Icons.calendar_month;
    }

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
                    
                    // 2. The Dynamic Row of Stat Cards
                    Row(
                      children: [
                        StatCard(
                          icon: stat1Icon,
                          title: stat1Title,
                          value: stat1Value,
                          valueSuffix: stat1Suffix,
                        ),
                        const SizedBox(width: 16),
                        const StatCard(
                          icon: Icons.two_wheeler,
                          title: "Dream Goal Delayed",
                          value: "+18", // You could make this dynamic too later!
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
                          progress: _secondsRemaining / _kTimerDurationSeconds,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 4. Bottom Action Area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: InterColors.creamBg,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Investment Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InvestmentPage()),
                        );
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
                  
                  // Pay Button (Locked/Unlocked)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLocked ? null : () {
                         // Proceed with payment
                         final provider = Provider.of<UserDataProvider>(context, listen: false);
                         provider.executeTransaction(widget.transactionAmount, "Impulse"); // Default tag if coming from here
                         
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successful!"), backgroundColor: Colors.green));
                         Navigator.popUntil(context, (r) => r.isFirst);
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
                  
                  // Emergency Override
                  TextButton(
                    onPressed: () {
                       final provider = Provider.of<UserDataProvider>(context, listen: false);
                       provider.executeTransaction(widget.transactionAmount, "Emergency");
                       
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency Override Activated")));
                       Navigator.popUntil(context, (r) => r.isFirst);
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