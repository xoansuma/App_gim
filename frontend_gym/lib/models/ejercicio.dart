class Ejercicio {
  final int? id;
  final String nombre;
  final String grupoMuscular;

  Ejercicio({
    this.id,
    required this.nombre,
    required this.grupoMuscular,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      nombre: json['nombre'],
      grupoMuscular: json['grupoMuscular'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'grupoMuscular': grupoMuscular,
    };
  }
}
