import 'package:flutter/material.dart';
import 'scanner_pay_page.dart';
import '../dashboard/dashboard_screen.dart';
// IMPORT THE NEW PAGE
import '../investment/investment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // The 3 main pages
  final List<Widget> _pages = [
    const ScannerPayPage(),      // Home with QR Scan
    const DashboardScreen(),     // The Graph UI
    const InvestmentPage(),      // THE NEW INVESTMENT PAGE
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2A9D8F), // Teal to match theme
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scanner Pay",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: "Invest",
          ),
        ],
      ),
    );
  }
}