import 'package:flutter/foundation.dart';
import '../models/owner.dart';
import '../database/database_helper.dart';

class OwnerViewModel extends ChangeNotifier {
  List<Owner> _owners = [];
  List<Owner> _filteredOwners = [];
  List<Owner> get owners => _filteredOwners;

  List<Owner> get filteredOwners => _filteredOwners;

  Future<void> loadOwners() async {
    try {
      _owners = await DatabaseHelper.instance.getAllOwners();
      _filteredOwners = _owners;
      notifyListeners();
    } catch (e) {
      print('Error loading owners: $e');
    }
  }

  Future<void> addOwner(Owner owner) async {
    try {
      await DatabaseHelper.instance.insertOwner(owner);
      await loadOwners();
    } catch (e) {
      print('Error adding owner: $e');
    }
  }

  void filterOwners(String query) {
    _filteredOwners = _owners.where((owner) =>
        owner.fullName.toLowerCase().contains(query.toLowerCase()) ||
        owner.dni.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  set owners(List<Owner> owners) {

    _owners = owners;

    notifyListeners();

  }
}

