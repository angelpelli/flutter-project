import 'package:flutter/foundation.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../database/database_helper.dart';

class StatisticsViewModel extends ChangeNotifier {
  int _totalPets = 0;
  int _totalStays = 0;
  double _totalRevenue = 0;

  int get totalPets => _totalPets;
  int get totalStays => _totalStays;
  double get totalRevenue => _totalRevenue;

  Future<void> loadStatistics() async {
    try {
      final pets = await DatabaseHelper.instance.getAllPets();
      final stays = await DatabaseHelper.instance.getAllStays();

      _totalPets = pets.length;
      _totalStays = stays.length;
      _totalRevenue = _calculateRevenue(pets, stays);

      notifyListeners();
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  double _calculateRevenue(List<Pet> pets, List<Stay> stays) {
    double revenue = 0;
    for (var stay in stays) {
      final pet = pets.firstWhere((p) => p.id == stay.petId);
      final days = stay.endDate.difference(stay.startDate).inDays;
      revenue += pet.dailyRate * days;
    }
    return revenue;
  }
}

