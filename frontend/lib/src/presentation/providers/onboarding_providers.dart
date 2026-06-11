import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  String cognitiveStyle = '';
  Map<String, String> knowledgeLevels = {}; // {'Variables': 'Básico', ...}
  List<String> selectedTopics = [];

  void updateCognitiveStyle(String style) { cognitiveStyle = style; notifyListeners(); }
  void updateKnowledge(String topic, String level) { knowledgeLevels[topic] = level; notifyListeners(); }
  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) selectedTopics.remove(topic);
    else selectedTopics.add(topic);
    notifyListeners();
  }
}