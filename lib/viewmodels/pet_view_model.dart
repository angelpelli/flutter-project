import 'package:flutter/foundation.dart';
import '../models/pet.dart';
import '../database/database_helper.dart';
import '../models/stay.dart';

/// ViewModel para la gestión de mascotas.
class PetViewModel extends ChangeNotifier {
  List<Pet> _pets = [];
  List<Pet> _filteredPets = [];
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  /// Obtiene la lista de mascotas.
  List<Pet> get pets => _filteredPets;

  /// Obtiene la lista de mascotas filtradas.
  List<Pet> get filteredPets => _filteredPets;

  /// Carga todas las mascotas desde la base de datos.
  Future<void> loadPets() async {
    try {
      _pets = await databaseHelper.getAllPets();
      _filteredPets = _pets;
      notifyListeners();
    } catch (e) {
      print('Error al cargar mascotas: $e');
    }
  }

  /// Añade una nueva mascota a la base de datos.
  ///
  /// [pet] es la mascota a añadir.
  Future<void> addPet(Pet pet) async {
    try {
      await databaseHelper.insertPet(pet);
      await loadPets();
    } catch (e) {
      print('Error al añadir mascota: $e');
    }
  }

  /// Actualiza una mascota existente en la base de datos.
  ///
  /// [pet] es la mascota a actualizar.
  Future<void> updatePet(Pet pet) async {
    try {
      await databaseHelper.updatePet(pet);
      await loadPets();
    } catch (e) {
      print('Error al actualizar mascota: $e');
    }
  }

  /// Filtra las mascotas basándose en una consulta.
  ///
  /// [query] es la cadena de búsqueda para filtrar las mascotas.
  void filterPets(String query) {
    _filteredPets = _pets.where((pet) =>
        pet.name.toLowerCase().contains(query.toLowerCase()) ||
        pet.breed.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  /// Obtiene las estancias para una mascota específica.
  ///
  /// [petId] es el ID de la mascota para la cual se buscan las estancias.
  Future<List<Stay>> getStaysForPet(String petId) async {
    try {
      return await databaseHelper.getStaysForPet(petId);
    } catch (e) {
      print('Error al obtener estancias para la mascota: $e');
      return [];
    }
  }
   set pets(List<Pet> pets) {

    _pets = pets;

    notifyListeners();

  }
}

