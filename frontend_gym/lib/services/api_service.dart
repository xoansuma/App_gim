import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/ejercicio.dart';
import '../models/entrenamiento.dart';
import '../models/plantilla_entrenamiento.dart';

class ApiService {
  // URL del servidor en tu red local
  static const String baseUrl = 'http://192.168.0.172:8080';

  // ==================== AUTENTICACIÓN ====================

  Future<Usuario> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Credenciales inválidas');
  }

  // ==================== USUARIOS ====================

  Future<List<Usuario>> getUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/api/usuarios'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Usuario.fromJson(json)).toList();
    }
    throw Exception('Error al cargar usuarios');
  }

  Future<Usuario> getUsuario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/usuarios/$id'));
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Error al cargar usuario');
  }

  Future<Usuario> getUsuarioPorEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/api/usuarios/email/$email'));
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Error al cargar usuario');
  }

  Future<Usuario> crearUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear usuario');
  }

  Future<Usuario> actualizarUsuario(int id, Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Error al actualizar usuario');
  }

  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/usuarios/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
  }

  // ==================== EJERCICIOS ====================

  Future<List<Ejercicio>> getEjercicios() async {
    final response = await http.get(Uri.parse('$baseUrl/api/ejercicios'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Ejercicio.fromJson(json)).toList();
    }
    throw Exception('Error al cargar ejercicios');
  }

  Future<Ejercicio> getEjercicio(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/ejercicios/$id'));
    if (response.statusCode == 200) {
      return Ejercicio.fromJson(json.decode(response.body));
    }
    throw Exception('Error al cargar ejercicio');
  }

  Future<List<Ejercicio>> buscarEjerciciosPorGrupo(String grupoMuscular) async {
    final response = await http.get(Uri.parse('$baseUrl/api/ejercicios/grupo/$grupoMuscular'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Ejercicio.fromJson(json)).toList();
    }
    throw Exception('Error al buscar ejercicios');
  }

  Future<List<Ejercicio>> buscarEjerciciosPorNombre(String nombre) async {
    final response = await http.get(Uri.parse('$baseUrl/api/ejercicios/buscar?nombre=$nombre'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Ejercicio.fromJson(json)).toList();
    }
    throw Exception('Error al buscar ejercicios');
  }

  Future<Ejercicio> crearEjercicio(Ejercicio ejercicio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/ejercicios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ejercicio.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Ejercicio.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear ejercicio');
  }

  Future<Ejercicio> actualizarEjercicio(int id, Ejercicio ejercicio) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/ejercicios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ejercicio.toJson()),
    );
    if (response.statusCode == 200) {
      return Ejercicio.fromJson(json.decode(response.body));
    }
    throw Exception('Error al actualizar ejercicio');
  }

  Future<void> eliminarEjercicio(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/ejercicios/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar ejercicio');
    }
  }

  // ==================== ENTRENAMIENTOS ====================

  Future<List<Entrenamiento>> getEntrenamientos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/entrenamientos'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Entrenamiento.fromJson(json)).toList();
    }
    throw Exception('Error al cargar entrenamientos');
  }

  Future<Entrenamiento> getEntrenamiento(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/entrenamientos/$id'));
    if (response.statusCode == 200) {
      return Entrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al cargar entrenamiento');
  }

  Future<List<Entrenamiento>> getEntrenamientosPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/entrenamientos/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Entrenamiento.fromJson(json)).toList();
    }
    throw Exception('Error al cargar entrenamientos del usuario');
  }

  Future<Entrenamiento> crearEntrenamiento(Entrenamiento entrenamiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/entrenamientos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entrenamiento.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Entrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear entrenamiento');
  }

  Future<Entrenamiento> actualizarEntrenamiento(int id, Entrenamiento entrenamiento) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/entrenamientos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entrenamiento.toJson()),
    );
    if (response.statusCode == 200) {
      return Entrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al actualizar entrenamiento');
  }

  Future<void> eliminarEntrenamiento(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/entrenamientos/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar entrenamiento');
    }
  }

  // ==================== EJERCICIOS-ENTRENAMIENTOS ====================

  Future<EjercicioEntrenamiento> agregarEjercicioAEntrenamiento(
      EjercicioEntrenamiento ejercicioEntrenamiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/ejercicios-entrenamientos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ejercicioEntrenamiento.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return EjercicioEntrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al agregar ejercicio al entrenamiento');
  }

  Future<List<EjercicioEntrenamiento>> getEjerciciosDeEntrenamiento(int entrenamientoId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/ejercicios-entrenamientos/entrenamiento/$entrenamientoId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => EjercicioEntrenamiento.fromJson(json)).toList();
    }
    throw Exception('Error al cargar ejercicios del entrenamiento');
  }

  Future<void> eliminarEjercicioDeEntrenamiento(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/ejercicios-entrenamientos/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar ejercicio del entrenamiento');
    }
  }

  // ==================== SERIES ====================

  Future<Serie> crearSerie(Serie serie) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/series'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(serie.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Serie.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear serie');
  }

  Future<List<Serie>> getSeriesDeEjercicioEntrenamiento(int ejercicioEntrenamientoId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/series/ejercicio-entrenamiento/$ejercicioEntrenamientoId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Serie.fromJson(json)).toList();
    }
    throw Exception('Error al cargar series');
  }

  Future<Serie> actualizarSerie(int id, Serie serie) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/series/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(serie.toJson()),
    );
    if (response.statusCode == 200) {
      return Serie.fromJson(json.decode(response.body));
    }
    throw Exception('Error al actualizar serie');
  }

  Future<void> eliminarSerie(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/series/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar serie');
    }
  }

  // ==================== PLANTILLAS DE ENTRENAMIENTO ====================

  Future<List<PlantillaEntrenamiento>> getPlantillasPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/plantillas/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => PlantillaEntrenamiento.fromJson(json)).toList();
    }
    throw Exception('Error al cargar plantillas');
  }

  Future<PlantillaEntrenamiento> getPlantilla(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/plantillas/$id'));
    if (response.statusCode == 200) {
      return PlantillaEntrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al cargar plantilla');
  }

  Future<PlantillaEntrenamiento> crearPlantilla(PlantillaEntrenamiento plantilla) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/plantillas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plantilla.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return PlantillaEntrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear plantilla');
  }

  Future<PlantillaEntrenamiento> actualizarPlantilla(int id, PlantillaEntrenamiento plantilla) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/plantillas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plantilla.toJson()),
    );
    if (response.statusCode == 200) {
      return PlantillaEntrenamiento.fromJson(json.decode(response.body));
    }
    throw Exception('Error al actualizar plantilla');
  }

  Future<void> eliminarPlantilla(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/plantillas/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar plantilla');
    }
  }

  Future<PlantillaEjercicio> agregarEjercicioAPlantilla(PlantillaEjercicio plantillaEjercicio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/plantillas-ejercicios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plantillaEjercicio.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return PlantillaEjercicio.fromJson(json.decode(response.body));
    }
    throw Exception('Error al agregar ejercicio a la plantilla');
  }

  Future<void> eliminarEjercicioDePlantilla(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/plantillas-ejercicios/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar ejercicio de la plantilla');
    }
  }
}
