import 'package:flutter/material.dart';
import '../views/statistics_view.dart';

class StatisticsButton extends StatelessWidget {
  const StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF202020),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Colors.white),
      ),
      onPressed: () => _showStatistics(context),
    );
  }

  void _showStatistics(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: const StatisticsView(),
          ),
        );
      },
    );
  }
}

