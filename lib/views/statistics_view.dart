import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/statistics_view_model.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  StatisticsViewState createState() => StatisticsViewState();
}

class StatisticsViewState extends State<StatisticsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<StatisticsViewModel>(context, listen: false).loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsViewModel>(
      builder: (context, statisticsViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Estadísticas', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF202020),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Estadísticas Generales', 
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard('Total de Mascotas', statisticsViewModel.totalPets.toString()),
                    _buildStatCard('Total de Estancias', statisticsViewModel.totalStays.toString()),
                    _buildStatCard('Ingresos Totales', '${statisticsViewModel.totalRevenue.toStringAsFixed(2)}€'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, 
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(value, 
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

