class Entrenamiento {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int usuarioId;
  final DateTime? fechaRealizacion;
  final List<EjercicioEntrenamiento>? ejercicios;

  Entrenamiento({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.usuarioId,
    this.fechaRealizacion,
    this.ejercicios,
  });

  factory Entrenamiento.fromJson(Map<String, dynamic> json) {
    return Entrenamiento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      usuarioId: json['usuarioId'],
      fechaRealizacion: json['fechaRealizacion'] != null
          ? DateTime.parse(json['fechaRealizacion'])
          : null,
      ejercicios: json['ejercicios'] != null
          ? (json['ejercicios'] as List)
              .map((e) => EjercicioEntrenamiento.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'usuarioId': usuarioId,
      'fechaRealizacion': fechaRealizacion?.toIso8601String(),
    };
  }
}

class EjercicioEntrenamiento {
  final int? id;
  final int? entrenamientoId;
  final int ejercicioId;
  final String? ejercicioNombre;
  final String? ejercicioGrupoMuscular;
  final int? orden;
  final String? notas;
  final List<Serie>? series;

  EjercicioEntrenamiento({
    this.id,
    this.entrenamientoId,
    required this.ejercicioId,
    this.ejercicioNombre,
    this.ejercicioGrupoMuscular,
    this.orden,
    this.notas,
    this.series,
  });

  factory EjercicioEntrenamiento.fromJson(Map<String, dynamic> json) {
    return EjercicioEntrenamiento(
      id: json['id'],
      entrenamientoId: json['entrenamientoId'],
      ejercicioId: json['ejercicioId'],
      ejercicioNombre: json['ejercicioNombre'],
      ejercicioGrupoMuscular: json['ejercicioGrupoMuscular'],
      orden: json['orden'],
      notas: json['notas'],
      series: json['series'] != null
          ? (json['series'] as List).map((e) => Serie.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entrenamientoId': entrenamientoId,
      'ejercicioId': ejercicioId,
      'orden': orden,
      'notas': notas,
    };
  }
}

class Serie {
  final int? id;
  final int? ejercicioEntrenamientoId;
  final int numeroSerie;
  final int repeticiones;
  final double? peso;
  final int? duracionSegundos;
  final String? notas;

  Serie({
    this.id,
    this.ejercicioEntrenamientoId,
    required this.numeroSerie,
    required this.repeticiones,
    this.peso,
    this.duracionSegundos,
    this.notas,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      id: json['id'],
      ejercicioEntrenamientoId: json['ejercicioEntrenamientoId'],
      numeroSerie: json['numeroSerie'],
      repeticiones: json['repeticiones'],
      peso: json['peso']?.toDouble(),
      duracionSegundos: json['duracionSegundos'],
      notas: json['notas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ejercicioEntrenamientoId': ejercicioEntrenamientoId,
      'numeroSerie': numeroSerie,
      'repeticiones': repeticiones,
      'peso': peso,
      'duracionSegundos': duracionSegundos,
      'notas': notas,
    };
  }
}
