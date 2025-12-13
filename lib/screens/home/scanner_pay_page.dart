import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/utils.dart';
import '../payment/qr_scanner.dart';
import '../profile/profile_page.dart';
import 'home_widgets.dart';

class ScannerPayPage extends StatelessWidget {
  const ScannerPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove default back button if any
        title: GestureDetector(
          // Click to open Profile Page
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          child: Row(
            children: [
              // Profile Avatar with Streak Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE07A5F), width: 2), // Terracotta border
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    ),
                  ),
                  // The Fire Badge
                  Positioned(
                    bottom: -2,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 12),
                          Text(
                            "${userData.currentStreak}",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Namaste", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Row(
                    children: [
                      const Text(
                        "Keerth",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LivingMaaAvatar(userData: userData),
              const SizedBox(height: 24),
              const BalanceCard(),
              const SizedBox(height: 24),
              const Text("Quick Payments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const SizedBox(height: 16),
              const QuickActionsGrid(),
              const SizedBox(height: 24),
              const Text("Recent Spending", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              const SizedBox(height: 10),
              ...userData.recentTransactions.map((tx) => TransactionTile(merchant: tx['merchant'], amount: tx['amount'], time: tx['time'], category: tx['category'], isNegative: tx['isNegative'])),
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