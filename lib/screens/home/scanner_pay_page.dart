import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/utils.dart';
import '../payment/qr_scanner.dart';
import 'home_widgets.dart';
import 'transaction_history_page.dart'; // Import history page

class ScannerPayPage extends StatelessWidget {
  const ScannerPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        title: const Row(children: [
          CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Namaste", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text("Keerth", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653)))
          ])
        ]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Updated to use the new Avatar widget
              LivingMaaAvatar(userData: userData),
              const SizedBox(height: 24),
              const BalanceCard(),
              const SizedBox(height: 24),
              const Text("Quick Payments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const SizedBox(height: 16),
              const QuickActionsGrid(),
              const SizedBox(height: 24),
              
              // --- UPDATED TRANSACTION LIST LOGIC ---
              const Text("Recent Spending (Last 10)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const SizedBox(height: 10),
              
              ...userData.recentTransactions.take(10).map((tx) => TransactionTile(
                merchant: tx['merchant'],
                amount: tx['amount'],
                time: tx['time'],
                category: tx['category'],
                isNegative: tx['isNegative']
              )),

              if (userData.recentTransactions.length > 10)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Full History",
                          style: TextStyle(
                            color: Color(0xFF264653),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16, color: Color(0xFF264653)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaaPageRoute(page: const QRScannerPage())),
        backgroundColor: const Color(0xFF264653),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text("Scan to Pay", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}