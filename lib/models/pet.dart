import 'package:uuid/uuid.dart';

/// Representa una mascota en el sistema.
class Pet {
  /// Identificador único de la mascota.
  final String id;

  /// Nombre de la mascota.
  final String name;

  /// Identificador del dueño de la mascota.
  final String ownerId;

  /// Raza de la mascota.
  final String breed;

  /// Edad de la mascota en años.
  final int age;

  /// Tarifa diaria para el cuidado de la mascota.
  final double dailyRate;

  /// Descripción adicional de la mascota.
  final String description;

  /// Número de microchip de la mascota.
  final String microchip;

  /// Crea una nueva instancia de [Pet].
  ///
  /// Si no se proporciona un [id], se generará automáticamente uno nuevo.
  Pet({
    String? id,
    required this.name,
    required this.ownerId,
    required this.breed,
    required this.age,
    required this.dailyRate,
    this.description = '',
    required this.microchip,
  }) : id = id ?? const Uuid().v4();

  /// Convierte la instancia de [Pet] a un mapa.
  ///
  /// Útil para almacenar la información de la mascota en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'breed': breed,
      'age': age,
      'dailyRate': dailyRate,
      'description': description,
      'microchip': microchip,
    };
  }

  /// Crea una instancia de [Pet] a partir de un mapa.
  ///
  /// Útil para recuperar la información de la mascota desde la base de datos.
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      ownerId: map['ownerId'],
      breed: map['breed'],
      age: map['age'],
      dailyRate: map['dailyRate'],
      description: map['description'],
      microchip: map['microchip'],
    );
  }
}

