import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'home_widgets.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final allTransactions = userData.recentTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        title: const Text(
          "Transaction History",
          style: TextStyle(color: Color(0xFF264653), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF264653)),
      ),
      body: allTransactions.isEmpty
          ? const Center(
              child: Text(
                "No transactions yet.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                final tx = allTransactions[index];
                return TransactionTile(
                  merchant: tx['merchant'],
                  amount: tx['amount'],
                  time: tx['time'],
                  category: tx['category'],
                  isNegative: tx['isNegative'],
                );
              },
            ),
    );
  }
}