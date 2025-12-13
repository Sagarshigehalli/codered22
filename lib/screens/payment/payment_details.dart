import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/utils.dart';
import '../intervention/intervention_screen.dart'; 

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});
  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tagSearchController = TextEditingController();
  String _selectedTag = "Groceries";
  bool _isProcessing = false; // Manages loading state

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    bool isLocked = userData.isLockedTag(_selectedTag);
    double displayBalance = userData.getBalanceForTag(_selectedTag);
    Color balanceColor = isLocked ? const Color(0xFFE07A5F) : const Color(0xFF2A9D8F);
    String balanceLabel = isLocked ? "Locked Balance for $_selectedTag" : "Spendable Balance";

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        title: const Text("Payment Details", style: TextStyle(color: Color(0xFF264653))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF264653)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.store, color: Color(0xFF264653)),
              ),
              const SizedBox(width: 16),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Paying to", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("General Store", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF264653))),
                Text("upi-id@okhdfc", style: TextStyle(color: Colors.grey, fontSize: 12))
              ])
            ]),
            const Divider(height: 40),
            Text("What is this for?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF264653))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userData.recentTags.map((tag) {
                bool isSelected = _selectedTag == tag;
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: const Color(0xFF264653),
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedTag = tag);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _tagSearchController,
                    decoration: const InputDecoration(hintText: "Search or Add custom tag...", border: InputBorder.none, icon: Icon(Icons.search, size: 20, color: Colors.grey)),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        userData.addTag(val);
                        setState(() => _selectedTag = val);
                        _tagSearchController.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (_tagSearchController.text.isNotEmpty) {
                    userData.addTag(_tagSearchController.text);
                    setState(() => _selectedTag = _tagSearchController.text);
                    _tagSearchController.clear();
                  }
                },
                icon: const Icon(Icons.add_circle, color: Color(0xFF264653)),
              )
            ]),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: balanceColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: balanceColor.withOpacity(0.3))),
              child: Row(children: [
                Icon(isLocked ? Icons.lock : Icons.account_balance_wallet, color: balanceColor),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(balanceLabel, style: TextStyle(color: balanceColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("₹${displayBalance.toStringAsFixed(0)}", style: TextStyle(color: balanceColor, fontWeight: FontWeight.bold, fontSize: 20))
                ])
              ]),
            ).animate().fadeIn(),
            const SizedBox(height: 20),
            const Text("Amount", style: TextStyle(color: Colors.grey)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF264653)),
              decoration: const InputDecoration(prefixText: "₹ ", border: InputBorder.none, hintText: "0"),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF264653), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 5),
                onPressed: _isProcessing ? null : () async {
                  double amount = double.tryParse(_amountController.text) ?? 0;
                  if (amount <= 0) return;

                  setState(() => _isProcessing = true);

                  // 1. Attempt API Call with Fail-Safe Logic
                  try {
                    // This will now respect the 5s timeout set in user_provider.dart
                    await userData.fetchMaaInsight(_selectedTag, amount);
                  } catch (e) {
                    debugPrint("API failed gracefully, continuing payment flow...");
                  }

                  if (!mounted) return;
                  setState(() => _isProcessing = false);

                  // 2. CHECK LOGIC (Intervention vs Direct Pay)
                  if (!isLocked && userData.requiresIntervention(amount)) {
                    // Navigate to Intervention (Financial Discipline Page)
                    Navigator.push(
                      context,
                      MaaPageRoute(
                        page: InterventionScreen(transactionAmount: amount),
                      ),
                    );
                  } else {
                    // Direct Pay
                    userData.executeTransaction(amount, _selectedTag);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successful!"), backgroundColor: Colors.green));
                      // Go back to Home
                      Navigator.popUntil(context, (r) => r.isFirst);
                    }
                  }
                },
                child: _isProcessing 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Pay Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}