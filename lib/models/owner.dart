import 'package:uuid/uuid.dart';

/// Representa al dueño de una mascota en el sistema.
class Owner {
  /// Identificador único del dueño.
  final String id;

  /// Nombre del dueño.
  final String firstName;

  /// Apellido del dueño.
  final String lastName;

  /// Documento Nacional de Identidad (DNI) del dueño.
  final String dni;

  /// Dirección del dueño.
  final String address;

  /// Crea una nueva instancia de [Owner].
  ///
  /// Si no se proporciona un [id], se generará automáticamente uno nuevo.
  Owner({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.address,
  }) : this.id = id ?? const Uuid().v4();

  /// Convierte la instancia de [Owner] a un mapa.
  ///
  /// Útil para almacenar la información del dueño en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'address': address,
    };
  }

  /// Crea una instancia de [Owner] a partir de un mapa.
  ///
  /// Útil para recuperar la información del dueño desde la base de datos.
  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      dni: map['dni'],
      address: map['address'],
    );
  }

  /// Obtiene el nombre completo del dueño.
  String get fullName => '$firstName $lastName';
}

