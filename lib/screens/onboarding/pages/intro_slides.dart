import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroSlides extends StatefulWidget {
  final VoidCallback onNext;
  const IntroSlides({super.key, required this.onNext});
  @override
  State<IntroSlides> createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  final PageController _slideController = PageController();
  int _slideIndex = 0;
  final List<Map<String, String>> _pages = [
    {
      "title": "Instant Payments,\nInstant Regret?",
      "desc": "UPI made spending easy. We make sure you don't spend what you don't have.",
      "icon": "💸",
    },
    {
      "title": "Meet Maa,\nYour Financial Guardian",
      "desc": "She locks your rent & bills automatically. She scolds you if you overspend.",
      "icon": "👵🏽",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _slideController,
              onPageChanged: (idx) => setState(() => _slideIndex = idx),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_pages[index]["icon"]!, style: const TextStyle(fontSize: 100))
                          .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 40),
                      Text(
                        _pages[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _pages[index]["desc"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56), backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
              onPressed: () {
                if (_slideIndex == _pages.length - 1) {
                  widget.onNext();
                } else {
                  _slideController.nextPage(duration: 300.ms, curve: Curves.ease);
                }
              },
              child: Text(_slideIndex == _pages.length - 1 ? "Get Started" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}