import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'pages/intro_slides.dart';
import 'pages/user_type_selection.dart';
import 'pages/salaried_input_form.dart';
import 'pages/unsalaried_scan_page.dart';
import 'pages/income_analysis_page.dart';
import 'pages/expense_analysis_page.dart';
import 'pages/statistics_reveal_page.dart';
// NEW IMPORTS
import 'pages/student_input_page.dart';
import 'pages/student_expense_statistics_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  bool _isStudentFlow = false;

  void _nextPage() =>
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
  
  void _goToPage(int page) => _pageController.animateToPage(
    page,
    duration: 400.ms,
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Index 0: Intro
          IntroSlides(onNext: _nextPage), 
          
          // Index 1: Selection
          UserTypeSelection(
            onSalaried: () {
              setState(() => _isStudentFlow = false);
              _goToPage(2);
            },
            onUnsalaried: () {
              setState(() => _isStudentFlow = false);
              _goToPage(3);
            },
            onStudent: () {
              setState(() => _isStudentFlow = true);
              _goToPage(7); // Jump to Student Input
            },
          ), 
          
          // Index 2: Salaried Input
          SalariedInputForm(onComplete: () => _goToPage(6)), 
          
          // Index 3: Scan Page (Used by Unsalaried AND Student)
          UnsalariedScanPage(
            onComplete: () {
              if (_isStudentFlow) {
                _goToPage(8); // Go to Student Stats
              } else {
                _goToPage(4); // Go to Income Analysis
              }
            },
          ), 
          
          // Index 4: Income Analysis
          IncomeAnalysisPage(onNext: () => _goToPage(5)), 
          
          // Index 5: Expense Analysis
          ExpenseAnalysisPage(onNext: () => _goToPage(6)), 
          
          // Index 6: Final Stats Reveal
          const StatisticsRevealPage(),

          // --- NEW PAGES ---
          
          // Index 7: Student Input
          StudentInputPage(onComplete: () => _goToPage(3)), // Go to Scan

          // Index 8: Student Expense Stats
          StudentExpenseStatisticsPage(onNext: () => _goToPage(6)), // Go to Final Stats
        ],
      ),
    );
  }
}