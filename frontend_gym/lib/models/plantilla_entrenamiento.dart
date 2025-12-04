class PlantillaEntrenamiento {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int usuarioId;
  final DateTime? fechaCreacion;
  final List<PlantillaEjercicio>? ejercicios;

  PlantillaEntrenamiento({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.usuarioId,
    this.fechaCreacion,
    this.ejercicios,
  });

  factory PlantillaEntrenamiento.fromJson(Map<String, dynamic> json) {
    return PlantillaEntrenamiento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      usuarioId: json['usuarioId'],
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'])
          : null,
      ejercicios: json['ejercicios'] != null
          ? (json['ejercicios'] as List)
              .map((e) => PlantillaEjercicio.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'usuarioId': usuarioId,
    };
  }
}

class PlantillaEjercicio {
  final int? id;
  final int? plantillaId;
  final int ejercicioId;
  final String? ejercicioNombre;
  final String? ejercicioGrupoMuscular;
  final int? orden;
  final String? notas;

  PlantillaEjercicio({
    this.id,
    this.plantillaId,
    required this.ejercicioId,
    this.ejercicioNombre,
    this.ejercicioGrupoMuscular,
    this.orden,
    this.notas,
  });

  factory PlantillaEjercicio.fromJson(Map<String, dynamic> json) {
    return PlantillaEjercicio(
      id: json['id'],
      plantillaId: json['plantillaId'],
      ejercicioId: json['ejercicioId'],
      ejercicioNombre: json['ejercicioNombre'],
      ejercicioGrupoMuscular: json['ejercicioGrupoMuscular'],
      orden: json['orden'],
      notas: json['notas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantillaId': plantillaId,
      'ejercicioId': ejercicioId,
      'orden': orden,
      'notas': notas,
    };
  }
}
