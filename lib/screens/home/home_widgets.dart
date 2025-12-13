import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/utils.dart';
// Ensure you have created lib/screens/locked/locked_funds_page.dart for this import to work:
import '../locked/locked_funds_page.dart';

class LivingMaaAvatar extends StatelessWidget {
  final UserDataProvider userData;
  const LivingMaaAvatar({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    // 1. Determine Logic
    double ratio = userData.dailyLimit > 0
        ? (userData.todaySpent / userData.dailyLimit)
        : 0;

    Color cardColor;
    String emoji;
    String title;
    String message;
    IconData statusIcon;

    if (ratio < 0.5) {
      // HAPPY ZONE
      cardColor = const Color(0xFFE5F9F6); // Soft Teal
      emoji = "🥰"; // Or Image.asset('assets/maa_happy.png')
      title = "Maa is Happy";
      message = "My raja beta! You are saving so well. \n+10 Ashirwad waiting for you.";
      statusIcon = Icons.stars;
    } else if (ratio < 0.9) {
      // SKEPTICAL ZONE
      cardColor = const Color(0xFFFFF4E5); // Soft Orange
      emoji = "🧐"; // Or Image.asset('assets/maa_skeptical.png')
      title = "Maa is Watching";
      message = "Beta, watch it. You are spending too fast. Slow down!";
      statusIcon = Icons.warning_amber;
    } else {
      // ANGRY ZONE
      cardColor = const Color(0xFFFFE5E5); // Soft Red
      emoji = "😡"; // Or Image.asset('assets/maa_angry.png')
      title = "Maa is Angry";
      message = "Bas! No more spending today! Don't disappoint me.";
      statusIcon = Icons.block;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Streak & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text("5 Day Streak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              Icon(statusIcon, color: Colors.black26),
            ],
          ),
          const SizedBox(height: 15),
          // Center: Avatar
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
              ],
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 45))),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: 2.seconds),

          const SizedBox(height: 15),
          // Bottom: Message
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF264653),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF264653).withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF264653), Color(0xFF2A9D8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // REMOVED 'const' here because withOpacity is dynamic
            color: const Color(0xFF2A9D8F).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Free to Spend",
            // REMOVED 'const' because withOpacity is dynamic
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${userData.freeToSpend.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaaPageRoute(page: const LockedFundsPage()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // REMOVED 'const' because withOpacity is dynamic
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock, color: Color(0xFFE07A5F), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Locked: ₹${userData.lockedAmount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 14,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionButton(context, Icons.person, "Contacts"),
        _actionButton(context, Icons.account_balance, "Bank"),
        _actionButton(context, Icons.history, "History"),
        _actionButton(context, Icons.settings, "Manage"),
      ],
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String merchant;
  final String amount;
  final String time;
  final String category;
  final bool isNegative;
  const TransactionTile({
    super.key,
    required this.merchant,
    required this.amount,
    required this.time,
    required this.category,
    required this.isNegative,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Text(
              isNegative ? "☕" : "💰",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isNegative ? Colors.black87 : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}