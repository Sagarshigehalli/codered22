import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF264653)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Financial Profile", style: GoogleFonts.poppins(color: const Color(0xFF264653), fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- 1. PROFILE HEADER ---
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE07A5F), width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Keerth", 
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF264653))
                ),
                Text(
                  userData.indiaWealthRank, // "Top 10%"
                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFE07A5F), fontWeight: FontWeight.w600)
                ),
              ],
            ).animate().fadeIn().scale(),

            const SizedBox(height: 30),

            // --- 2. GAMIFIED STREAK CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFFF5E62).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current Streak", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                      Row(
                        children: [
                          Text("${userData.currentStreak}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          const Text("Days", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text("Max: ${userData.maxStreak} Days", style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    ],
                  ),
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 60)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 3. STATS GRID ---
            Row(
              children: [
                _buildStatCard("Total Saved", "₹${userData.totalLifetimeSavings.toStringAsFixed(0)}", Icons.savings, Colors.green),
                const SizedBox(width: 16),
                _buildStatCard("Grade", userData.financialGrade, Icons.school, Colors.blue),
              ],
            ),

            const SizedBox(height: 24),

            // --- 4. BADGES SECTION ---
            Align(alignment: Alignment.centerLeft, child: Text("Earned Badges", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF264653)))),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildBadge("Saver", "🏆", true),
                _buildBadge("Streak", "🔥", true),
                _buildBadge("Investor", "📈", false),
                _buildBadge("Budget", "🛡️", true),
                _buildBadge("Guru", "🧘", false),
                _buildBadge("Maa's Fav", "❤️", true),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            Text(value, style: GoogleFonts.poppins(color: const Color(0xFF264653), fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String emoji, bool unlocked) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: unlocked ? Colors.white : Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: unlocked ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)] : [],
          ),
          child: Center(
            child: Text(
              emoji, 
              style: TextStyle(fontSize: 30, color: unlocked ? null : Colors.grey.withOpacity(0.5))
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: GoogleFonts.poppins(
            fontSize: 12, 
            color: unlocked ? const Color(0xFF264653) : Colors.grey
          )
        )
      ],
    );
  }
}