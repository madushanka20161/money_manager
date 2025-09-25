import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Onboarding extends StatelessWidget {
  final VoidCallback onDone;
  const Onboarding({super.key, required this.onDone});
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(title: "Welcome to Money Mate", body: "Track expenses quickly.", image: const Icon(Icons.account_balance_wallet, size: 120,)),
        PageViewModel(title: "Smart Categories", body: "Organize and reorder easily.", image: const Icon(Icons.category, size: 120)),
        PageViewModel(title: "Insights", body: "See trends and budgets.", image: const Icon(Icons.insights, size: 120)),
      ],
      onDone: onDone,
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Start"),
    );
  }
}