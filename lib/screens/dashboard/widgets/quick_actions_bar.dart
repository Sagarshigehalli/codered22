import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: TextStyle(color: DashboardColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionButton(icon: Icons.tune, label: 'Adjust Goals'),
            _ActionButton(icon: Icons.receipt_long, label: 'View Transactions'),
            _ActionButton(icon: Icons.download, label: 'Export Report'),
            _ActionButton(icon: Icons.savings_outlined, label: 'Plan Retirement'),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DashboardColors.cardBackground,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, color: DashboardColors.textDark),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: DashboardColors.textDark, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}