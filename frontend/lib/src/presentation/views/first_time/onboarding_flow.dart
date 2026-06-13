import 'package:flutter/material.dart';
import 'steps/cognitive_style_step.dart';
import 'steps/knowledge_level_step.dart';
import 'steps/interest_topics_step.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 3;

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos el porcentaje de progreso lineal
    double progressPercent = (_currentPage + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF001489)),
                onPressed: _previousPage,
              )
            : null,
        title: const Text(
          "EduCode AI",
          style: TextStyle(color: Color(0xFF001489), fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
            value: progressPercent,
            backgroundColor: const Color(0xE0E0E0FF),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF001489)),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Evita el swipe manual errático
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          CognitiveStyleStep(onNext: _nextPage),
          KnowledgeLevelStep(onNext: _nextPage),
          InterestTopicsStep(),
        ],
      ),
    );
  }
}