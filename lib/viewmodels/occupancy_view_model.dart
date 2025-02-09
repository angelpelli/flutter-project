import 'package:flutter/foundation.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../database/database_helper.dart';

class OccupancyViewModel extends ChangeNotifier {
  List<bool> _hallway1Occupancy = List.generate(50, (index) => false);
  List<bool> _hallway2Occupancy = List.generate(50, (index) => false);
  List<bool> _hallway3Occupancy = List.generate(50, (index) => false);

  List<bool> get hallway1Occupancy => _hallway1Occupancy;
  List<bool> get hallway2Occupancy => _hallway2Occupancy;
  List<bool> get hallway3Occupancy => _hallway3Occupancy;

  double _occupancyPercentage = 0.0;
  int _occupiedKennels = 0;
  int _totalKennels = 150;
  int _cleaningKennels = 0;
  int _maintenanceKennels = 0;

  double get occupancyPercentage => _occupancyPercentage;
  int get occupiedKennels => _occupiedKennels;
  int get totalKennels => _totalKennels;
  int get cleaningKennels => _cleaningKennels;
  int get maintenanceKennels => _maintenanceKennels;

  List<Pet> _pets = [];
  List<Pet> get pets => _pets;

  Future<void> loadOccupancy() async {
    try {
      final stays = await DatabaseHelper.instance.getAllStays();
      _pets = await DatabaseHelper.instance.getAllPets();
      if (_pets.isEmpty) {
        print('No hay mascotas registradas');
      }
      _updateOccupancy(stays);
      notifyListeners();
    } catch (e) {
      print('Error loading occupancy: $e');
    }
  }

  void _updateOccupancy(List<Stay> stays) {
    _resetOccupancy();

    for (var stay in stays) {
      if (stay.startDate.isBefore(DateTime.now()) && stay.endDate.isAfter(DateTime.now())) {
        _occupyKennel(stay.petId);
      }
    }

    _calculateStatistics();
  }

  void _resetOccupancy() {
    _hallway1Occupancy = List.generate(50, (index) => false);
    _hallway2Occupancy = List.generate(50, (index) => false);
    _hallway3Occupancy = List.generate(50, (index) => false);
  }

  void _occupyKennel(String petId) {
    try {
      int kennelNumber = int.tryParse(petId) ?? 0;
      if (kennelNumber > 0 && kennelNumber <= 50) {
        _hallway1Occupancy[kennelNumber - 1] = true;
      } else if (kennelNumber > 50 && kennelNumber <= 100) {
        _hallway2Occupancy[kennelNumber - 51] = true;
      } else if (kennelNumber > 100 && kennelNumber <= 150) {
        _hallway3Occupancy[kennelNumber - 101] = true;
      }
    } catch (e) {
      print('Error al ocupar el canil: $e');
    }
  }

  void _calculateStatistics() {
    _occupiedKennels = _hallway1Occupancy.where((occupied) => occupied).length +
                       _hallway2Occupancy.where((occupied) => occupied).length +
                       _hallway3Occupancy.where((occupied) => occupied).length;
    _occupancyPercentage = _occupiedKennels / _totalKennels;
    _cleaningKennels = 5;
    _maintenanceKennels = 3;
  }

  void toggleKennelOccupancy(int hallway, int kennelIndex) {
    switch (hallway) {
      case 1:
        _hallway1Occupancy[kennelIndex] = !_hallway1Occupancy[kennelIndex];
        break;
      case 2:
        _hallway2Occupancy[kennelIndex] = !_hallway2Occupancy[kennelIndex];
        break;
      case 3:
        _hallway3Occupancy[kennelIndex] = !_hallway3Occupancy[kennelIndex];
        break;
    }
    _calculateStatistics();
    notifyListeners();
  }
}

