import 'package:flutter/foundation.dart';
import '../models/stay.dart';
import '../models/pet.dart';
import '../models/owner.dart';
import '../database/database_helper.dart';

class StayViewModel extends ChangeNotifier {
  List<Stay> _stays = [];
  List<Stay> get stays => _stays;

  List<Pet> _pets = [];
  List<Pet> get pets => _pets;

  List<Owner> _owners = [];
  List<Owner> get owners => _owners;

  Pet? _selectedPet;
  Pet? get selectedPet => _selectedPet;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;

  DateTime? _rangeStart;
  DateTime? get rangeStart => _rangeStart;

  DateTime? _rangeEnd;
  DateTime? get rangeEnd => _rangeEnd;

  Future<void> loadStays() async {
    try {
      _stays = await DatabaseHelper.instance.getAllStays();
      await loadPets();
      await loadOwners();
      notifyListeners();
    } catch (e) {
      print('Error loading stays: $e');
    }
  }

  Future<void> loadPets() async {
    try {
      _pets = await DatabaseHelper.instance.getAllPets();
      notifyListeners();
    } catch (e) {
      print('Error loading pets: $e');
    }
  }

  Future<void> loadOwners() async {
    try {
      _owners = await DatabaseHelper.instance.getAllOwners();
      notifyListeners();
    } catch (e) {
      print('Error loading owners: $e');
    }
  }

  Future<void> saveStay() async {
    if (_selectedPet != null && _rangeStart != null && _rangeEnd != null) {
      final stay = Stay(
        petId: _selectedPet!.id,
        startDate: _rangeStart!,
        endDate: _rangeEnd!,
      );
      try {
        await DatabaseHelper.instance.insertStay(stay);
        await loadStays();
      } catch (e) {
        print('Error saving stay: $e');
      }
    }
  }

  Future<void> deleteStay(String stayId) async {
    try {
      await DatabaseHelper.instance.deleteStay(stayId);
      await loadStays();
    } catch (e) {
      print('Error deleting stay: $e');
    }
  }

  Future<void> updateStay(Stay stay) async {
    try {
      await DatabaseHelper.instance.updateStay(stay);
      await loadStays();
    } catch (e) {
      print('Error updating stay: $e');
    }
  }

  void setSelectedPet(Pet? pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _rangeStart = start;
    _rangeEnd = end;
    notifyListeners();
  }
}

