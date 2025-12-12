import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class InterventionScreen extends StatefulWidget {
  final double amount;
  final String merchant;
  const InterventionScreen({super.key, required this.amount, required this.merchant});
  @override
  State<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> with TickerProviderStateMixin {
  int _countdown = 5;
  bool _canPay = false;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _breathingController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  void _startTimer() async {
    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdown--);
    }
    if (mounted) setState(() => _canPay = true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    double epm = userData.earningsPerMinute == 0 ? 10.0 : userData.earningsPerMinute;
    int minutesOfWork = (widget.amount / epm).round();
    String scolding = userData.getTagScolding(widget.merchant);

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              AnimatedBuilder(animation: _breathingController, builder: (context, child) => Transform.scale(scale: 1.0 + (_breathingController.value * 0.1), child: const CircleAvatar(radius: 50, backgroundColor: Color(0xFFE07A5F), child: Text("😤", style: TextStyle(fontSize: 50))))),
              const SizedBox(height: 30),
              Text(scolding, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)), child: Column(children: [const Text("This expense costs:", style: TextStyle(color: Colors.white70)), Text("$minutesOfWork Minutes", style: const TextStyle(color: Color(0xFFE07A5F), fontSize: 32, fontWeight: FontWeight.bold)), const Text("of your hard work.", style: TextStyle(color: Colors.white, fontSize: 18))])),
              const Spacer(),
              if (!_canPay) ...[Text("Maa is counting... $_countdown", style: const TextStyle(color: Colors.white54)), LinearProgressIndicator(value: 1 - (_countdown / 5), color: const Color(0xFFE07A5F))],
              if (_canPay) Row(children: [Expanded(child: OutlinedButton(onPressed: () { Provider.of<UserDataProvider>(context, listen: false).executeTransaction(widget.amount, widget.merchant); Navigator.popUntil(context, (r) => r.isFirst); }, child: const Text("Yes, Pay", style: TextStyle(color: Colors.white)))), const SizedBox(width: 10), Expanded(child: ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE07A5F)), child: const Text("Sorry Maa")))]),
            ],
          ),
        ),
      ),
    );
  }
}