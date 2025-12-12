import 'package:flutter/material.dart';
import '../dashboard_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              // Replace with actual user image or asset
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=68'),
            ),
            const SizedBox(width: 12),
            Text(
              'Arjun Kumar',
              style: TextStyle(
                color: DashboardColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: DashboardColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'December 2025',
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              style: const TextStyle(color: DashboardColors.textDark, fontWeight: FontWeight.w600),
              onChanged: (String? newValue) {},
              items: <String>['December 2025', 'November 2025']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}