import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserTypeSelection extends StatelessWidget {
  final VoidCallback onSalaried;
  final VoidCallback onUnsalaried;
  const UserTypeSelection({super.key, required this.onSalaried, required this.onUnsalaried});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("How do you earn?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF264653)), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            _typeButton(context, "Salaried", "Steady monthly income", Icons.business_center, onSalaried),
            const SizedBox(height: 20),
            _typeButton(context, "Unsalaried", "Freelance / Business", Icons.store, onUnsalaried),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(BuildContext context, String title, String sub, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF264653))), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}