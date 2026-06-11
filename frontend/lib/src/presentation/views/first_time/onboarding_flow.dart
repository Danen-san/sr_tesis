import 'package:flutter/material.dart';
import 'steps/cognitive_style_step.dart';
import 'steps/knowledge_level_step.dart';
import 'steps/interest_topics_step.dart';
import 'loading_ai_screen.dart';

class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();

  void nextStep() {
    _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(), // Bloqueamos deslizamiento manual
        children: [
          CognitiveStyleStep(onNext: nextStep),
          KnowledgeLevelStep(onNext: nextStep),
          InterestTopicsStep(onNext: () {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoadingAiScreen()));
          }),
        ],
      ),
    );
  }
}