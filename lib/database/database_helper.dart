import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pet.dart';
import '../models/stay.dart';
import '../models/owner.dart';
import 'dart:io';

/// Clase auxiliar para manejar las operaciones de la base de datos.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Obtiene la instancia de la base de datos.
  ///
  /// Si la base de datos aún no ha sido inicializada, la crea.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cistercan.db');
    return _database!;
  }

  /// Inicializa la base de datos.
  ///
  /// Crea el archivo de la base de datos si no existe.
  Future<Database> _initDB(String filePath) async {
    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final appDocDir = await getApplicationDocumentsDirectory();
      path = join(appDocDir.path, filePath);
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Crea las tablas de la base de datos.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id TEXT PRIMARY KEY,
        name TEXT,
        ownerId TEXT,
        breed TEXT,
        age INTEGER,
        dailyRate REAL,
        description TEXT,
        microchip TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE owners(
        id TEXT PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        dni TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE stays(
        id TEXT PRIMARY KEY,
        petId TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');
  }

  // Métodos para Pet

  /// Inserta una nueva mascota en la base de datos.
  Future<String> insertPet(Pet pet) async {
    final db = await database;
    await db.insert('pets', pet.toMap());
    return pet.id;
  }

  /// Obtiene todas las mascotas de la base de datos.
  Future<List<Pet>> getAllPets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pets');
    return List.generate(maps.length, (i) => Pet.fromMap(maps[i]));
  }

  /// Actualiza la información de una mascota en la base de datos.
  Future<void> updatePet(Pet pet) async {
    final db = await database;
    await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  /// Elimina una mascota de la base de datos.
  Future<void> deletePet(String petId) async {
    final db = await database;
    await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [petId],
    );
  }

  // Métodos para Owner

  /// Inserta un nuevo dueño en la base de datos.
  Future<String> insertOwner(Owner owner) async {
    final db = await database;
    await db.insert('owners', owner.toMap());
    return owner.id;
  }

  /// Obtiene todos los dueños de la base de datos.
  Future<List<Owner>> getAllOwners() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('owners');
    return List.generate(maps.length, (i) => Owner.fromMap(maps[i]));
  }

  /// Actualiza la información de un dueño en la base de datos.
  Future<void> updateOwner(Owner owner) async {
    final db = await database;
    await db.update(
      'owners',
      owner.toMap(),
      where: 'id = ?',
      whereArgs: [owner.id],
    );
  }

  /// Elimina un dueño de la base de datos.
  Future<void> deleteOwner(String ownerId) async {
    final db = await database;
    await db.delete(
      'owners',
      where: 'id = ?',
      whereArgs: [ownerId],
    );
  }

  // Métodos para Stay

  /// Inserta una nueva estancia en la base de datos.
  Future<String> insertStay(Stay stay) async {
    final db = await database;
    await db.insert('stays', stay.toMap());
    return stay.id;
  }

  /// Obtiene todas las estancias de la base de datos.
  Future<List<Stay>> getAllStays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stays');
    return List.generate(maps.length, (i) => Stay.fromMap(maps[i]));
  }

  /// Obtiene todas las estancias de una mascota específica.
  Future<List<Stay>> getStaysForPet(String petId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stays',
      where: 'petId = ?',
      whereArgs: [petId],
    );
    return List.generate(maps.length, (i) => Stay.fromMap(maps[i]));
  }

  /// Actualiza la información de una estancia en la base de datos.
  Future<void> updateStay(Stay stay) async {
    final db = await database;
    await db.update(
      'stays',
      stay.toMap(),
      where: 'id = ?',
      whereArgs: [stay.id],
    );
  }

  /// Elimina una estancia de la base de datos.
  Future<void> deleteStay(String stayId) async {
    final db = await database;
    await db.delete(
      'stays',
      where: 'id = ?',
      whereArgs: [stayId],
    );
  }

  /// Cierra la conexión con la base de datos.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  /// Inserta datos de prueba en la base de datos.
  Future<void> insertTestData() async {
    // Insertar dueños de prueba
    List<Owner> owners = [
      Owner(firstName: 'Juan', lastName: 'Pérez', dni: '12345678A', address: 'Calle Mayor 1, Madrid'),
      Owner(firstName: 'María', lastName: 'García', dni: '87654321B', address: 'Avenida Principal 2, Barcelona'),
      Owner(firstName: 'Carlos', lastName: 'Rodríguez', dni: '11223344C', address: 'Plaza Central 3, Valencia'),
    ];

    for (var owner in owners) {
      await insertOwner(owner);
    }

    // Insertar mascotas de prueba
    List<Pet> pets = [
      Pet(name: 'Max', ownerId: owners[0].id, breed: 'Labrador', age: 5, dailyRate: 20.0, description: 'Perro amigable y juguetón', microchip: 'CHIP001'),
      Pet(name: 'Luna', ownerId: owners[0].id, breed: 'Bulldog', age: 3, dailyRate: 18.0, description: 'Perrita tranquila y cariñosa', microchip: 'CHIP002'),
      Pet(name: 'Rocky', ownerId: owners[1].id, breed: 'Pastor Alemán', age: 6, dailyRate: 22.0, description: 'Perro guardián y leal', microchip: 'CHIP003'),
      Pet(name: 'Mia', ownerId: owners[2].id, breed: 'Chihuahua', age: 2, dailyRate: 15.0, description: 'Perrita pequeña y enérgica', microchip: 'CHIP004'),
      Pet(name: 'Toby', ownerId: owners[2].id, breed: 'Golden Retriever', age: 4, dailyRate: 21.0, description: 'Perro amigable y obediente', microchip: 'CHIP005'),
    ];

    for (var pet in pets) {
      await insertPet(pet);
    }

    // Insertar estancias de prueba
    List<Stay> stays = [
      Stay(petId: pets[0].id, startDate: DateTime.now().subtract(const Duration(days: 5)), endDate: DateTime.now().add(const Duration(days: 2))),
      Stay(petId: pets[2].id, startDate: DateTime.now().subtract(const Duration(days: 3)), endDate: DateTime.now().add(const Duration(days: 4))),
      Stay(petId: pets[4].id, startDate: DateTime.now().add(const Duration(days: 1)), endDate: DateTime.now().add(const Duration(days: 8))),
    ];

    for (var stay in stays) {
      await insertStay(stay);
    }
  }
}

