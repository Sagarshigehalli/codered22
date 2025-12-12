import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class ExpenseAnalysisPage extends StatefulWidget {
  final VoidCallback onNext;
  const ExpenseAnalysisPage({super.key, required this.onNext});
  @override
  State<ExpenseAnalysisPage> createState() => _ExpenseAnalysisPageState();
}

class _ExpenseAnalysisPageState extends State<ExpenseAnalysisPage> {
  final _rentCtrl = TextEditingController();
  final _utilitiesCtrl = TextEditingController();
  final _emiCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserDataProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Fixed Expenses", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFE07A5F).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.info_outline, color: Color(0xFFE07A5F)), const SizedBox(width: 10), Expanded(child: Text("Avg. Monthly Debit found: ₹${data.detectedMonthlyExpense.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE07A5F))))])),
              const SizedBox(height: 30),
              const Text("Confirm Fixed Obligations:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(controller: _rentCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Rent")),
              const SizedBox(height: 16),
              TextField(controller: _utilitiesCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Utilities")),
              const SizedBox(height: 16),
              TextField(controller: _emiCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "EMI / Debt")),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final rent = double.tryParse(_rentCtrl.text) ?? 0;
                    final util = double.tryParse(_utilitiesCtrl.text) ?? 0;
                    final emi = double.tryParse(_emiCtrl.text) ?? 0;
                    Provider.of<UserDataProvider>(context, listen: false).finalizeUnsalariedProfile(confirmedIncome: data.totalBalance, workHours: 40, rent: rent, utilities: util, emi: emi);
                    widget.onNext();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF264653), foregroundColor: Colors.white),
                  child: const Text("Analyze Financial Health"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}