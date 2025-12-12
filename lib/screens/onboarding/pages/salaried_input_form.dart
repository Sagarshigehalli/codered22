import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../core/utils.dart';

class SalariedInputForm extends StatefulWidget {
  final VoidCallback onComplete;
  const SalariedInputForm({super.key, required this.onComplete});
  @override
  State<SalariedInputForm> createState() => _SalariedInputFormState();
}

class _SalariedInputFormState extends State<SalariedInputForm> {
  final _salaryCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();
  final _rentCtrl = TextEditingController();
  final _utilitiesCtrl = TextEditingController();
  final _emiCtrl = TextEditingController();
  int _currentStep = 0;
  final PageController _stepController = PageController();

  void _nextStep() {
    if (_currentStep == 0) {
      if (_salaryCtrl.text.isNotEmpty) {
        setState(() => _currentStep = 1);
        _stepController.nextPage(duration: 300.ms, curve: Curves.easeInOut);
      }
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    final income = double.tryParse(_salaryCtrl.text) ?? 0;
    final hours = double.tryParse(_hoursCtrl.text) ?? 40;
    final rent = double.tryParse(_rentCtrl.text) ?? 0;
    final utilities = double.tryParse(_utilitiesCtrl.text) ?? 0;
    final emi = double.tryParse(_emiCtrl.text) ?? 0;

    if (income > 0) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => const MaaLoadingDialog());
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context);
        Provider.of<UserDataProvider>(context, listen: false).setSalariedProfile(income: income, rent: rent, utilities: utilities, emi: emi, weeklyHours: hours);
        widget.onComplete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _stepController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep("Earnings", "Maa needs to know your income.", [_field(_salaryCtrl, "Monthly Income"), _field(_hoursCtrl, "Weekly Hours")], "Next", _nextStep),
            _buildStep("Fixed Bills", "Only enter amounts. We will setup payments later.", [_field(_rentCtrl, "Total Rent"), _field(_utilitiesCtrl, "Total Utilities"), _field(_emiCtrl, "Total EMI")], "Analyze", _nextStep),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String sub, List<Widget> fields, String btnText, VoidCallback onBtn) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF264653))), Text(sub, style: const TextStyle(color: Colors.grey)), const SizedBox(height: 30), ...fields, const Spacer(), SizedBox(width: double.infinity, height: 56, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE07A5F), foregroundColor: Colors.white), onPressed: onBtn, child: Text(btnText)))]),
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return Padding(padding: const EdgeInsets.only(bottom: 20), child: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: label, prefixText: "₹ ")));
  }
}