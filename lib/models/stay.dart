import 'package:uuid/uuid.dart';

/// Representa una estancia de una mascota en el sistema.
class Stay {
  /// Identificador único de la estancia.
  final String id;

  /// Identificador de la mascota asociada a esta estancia.
  final String petId;

  /// Fecha de inicio de la estancia.
  final DateTime startDate;

  /// Fecha de fin de la estancia.
  final DateTime endDate;

  /// Crea una nueva instancia de [Stay].
  ///
  /// Si no se proporciona un [id], se generará automáticamente uno nuevo.
  Stay({
    String? id,
    required this.petId,
    required this.startDate,
    required this.endDate,
  }) : id = id ?? const Uuid().v4();

  /// Convierte la instancia de [Stay] a un mapa.
  ///
  /// Útil para almacenar la información de la estancia en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  /// Crea una instancia de [Stay] a partir de un mapa.
  ///
  /// Útil para recuperar la información de la estancia desde la base de datos.
  factory Stay.fromMap(Map<String, dynamic> map) {
    return Stay(
      id: map['id'],
      petId: map['petId'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}

