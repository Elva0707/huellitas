class Mascota {
  String id;
  String nombre;
  String raza;
  String edad;
  String imagen; // Campo agregado para la URL de la imagen

  Mascota({
    required this.id,
    required this.nombre,
    required this.raza,
    required this.edad,
    required this.imagen, // Agregado al constructor
  });

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "raza": raza,
      "edad": edad,
      "imagen": imagen, // Agregado al mapa
    };
  }

  factory Mascota.fromMap(String id, Map<String, dynamic> map) {
    return Mascota(
      id: id,
      nombre: map["nombre"] ?? "",
      raza: map["raza"] ?? "",
      edad: map["edad"] ?? "",
      imagen: map["imagen"] ?? "", // Agregado con valor por defecto
    );
  }
}