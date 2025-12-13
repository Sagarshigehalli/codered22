import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../core/utils.dart';

class StudentInputPage extends StatefulWidget {
  final VoidCallback onComplete;
  const StudentInputPage({super.key, required this.onComplete});

  @override
  State<StudentInputPage> createState() => _StudentInputPageState();
}

class _StudentInputPageState extends State<StudentInputPage> {
  final _pocketMoneyCtrl = TextEditingController();

  Future<void> _submit() async {
    final pocketMoney = double.tryParse(_pocketMoneyCtrl.text) ?? 0;

    if (pocketMoney > 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const MaaLoadingDialog(),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
        Provider.of<UserDataProvider>(
          context,
          listen: false,
        ).setStudentProfile(pocketMoney: pocketMoney);
        widget.onComplete();
      }
    }
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
              const Text(
                "Student Finances",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264653),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Maa helps you manage your allowance smartly.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _pocketMoneyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Monthly Pocket Money",
                  prefixText: "₹ ",
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE07A5F),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}