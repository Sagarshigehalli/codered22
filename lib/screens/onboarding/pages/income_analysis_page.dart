import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class IncomeAnalysisPage extends StatefulWidget {
  final VoidCallback onNext;
  const IncomeAnalysisPage({super.key, required this.onNext});
  @override
  State<IncomeAnalysisPage> createState() => _IncomeAnalysisPageState();
}

class _IncomeAnalysisPageState extends State<IncomeAnalysisPage> {
  final _incomeCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = Provider.of<UserDataProvider>(context, listen: false);
    _incomeCtrl.text = data.detectedMonthlyIncome.toStringAsFixed(0);
    _hoursCtrl.text = "40";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Income Analysis", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const Text("Maa found this average monthly income.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              TextField(controller: _incomeCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Avg. Monthly Income (₹)")),
              const SizedBox(height: 20),
              TextField(controller: _hoursCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Weekly Work Hours")),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final income = double.tryParse(_incomeCtrl.text) ?? 0;
                    Provider.of<UserDataProvider>(context, listen: false).totalBalance = income;
                    final data = Provider.of<UserDataProvider>(context, listen: false);
                    double monthlyMinutes = (double.tryParse(_hoursCtrl.text) ?? 40) * 4 * 60;
                    data.earningsPerMinute = (monthlyMinutes > 0) ? (income / monthlyMinutes) : 0;
                    widget.onNext();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE07A5F), foregroundColor: Colors.white),
                  child: const Text("Next: Expenses"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}