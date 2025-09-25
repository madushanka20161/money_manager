import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class TourHome extends StatefulWidget {
  const TourHome({super.key});
  @override
  State<TourHome> createState() => _TourHomeState();
}

class _TourHomeState extends State<TourHome> {
  final keyAdd = GlobalKey();
  final keyFilter = GlobalKey();
  final keyChart = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  Future<void> _maybeStartTour() async {
    ShowCaseWidget.of(context).startShowCase([keyAdd, keyFilter, keyChart]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Money Mate"),
        actions: [
          Showcase(key: keyFilter, description: "Filter your transactions", child: IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})),
        ],
      ),
      floatingActionButton: Showcase(
        key: keyAdd,
        description: "Add a new expense",
        child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      ),
      body: Center(
        child: Showcase(
          key: keyChart,
          description: "View spending insights",
          child: Container(width: 220, height: 140, color: Colors.grey.shade300, alignment: Alignment.center, child: const Text("Insights Card")),
        ),
      ),
    );
  }
}