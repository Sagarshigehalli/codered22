import 'package:flutter/material.dart';
import 'investment_widgets.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InvestmentHeader(),
              const SizedBox(height: 24),
              const ImpulseSavingsCard(),
              const SizedBox(height: 20),
              const PrimaryGoalCard(),
              const SizedBox(height: 24),
              // Options Row
              const Row(
                children: [
                  InvestmentOptionCard(icon: Icons.show_chart, title: "Index Fund", risk: "Low Risk", riskColor: Colors.green),
                  SizedBox(width: 12),
                  InvestmentOptionCard(icon: Icons.account_balance, title: "Bank FD", risk: "Low Risk", riskColor: Colors.green),
                  SizedBox(width: 12),
                  InvestmentOptionCard(icon: Icons.house, title: "Property Goal", risk: "Medium Risk", riskColor: Colors.amber),
                ],
              ),
              const SizedBox(height: 24),
              const AutoInvestTile(),
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}