import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'pages/intro_slides.dart';
import 'pages/user_type_selection.dart';
import 'pages/salaried_input_form.dart';
import 'pages/unsalaried_scan_page.dart';
import 'pages/income_analysis_page.dart';
import 'pages/expense_analysis_page.dart';
import 'pages/statistics_reveal_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();

  void _nextPage() => _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
  void _goToPage(int page) => _pageController.animateToPage(page, duration: 400.ms, curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          IntroSlides(onNext: _nextPage),
          UserTypeSelection(onSalaried: () => _goToPage(2), onUnsalaried: () => _goToPage(3)),
          SalariedInputForm(onComplete: () => _goToPage(6)),
          UnsalariedScanPage(onComplete: () => _goToPage(4)),
          IncomeAnalysisPage(onNext: () => _goToPage(5)),
          ExpenseAnalysisPage(onNext: () => _goToPage(6)),
          const StatisticsRevealPage(),
        ],
      ),
    );
  }
}