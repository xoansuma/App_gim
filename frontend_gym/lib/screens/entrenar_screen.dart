import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/plantilla_entrenamiento.dart';
import '../models/entrenamiento.dart';
import '../services/api_service.dart';
import 'sesion_entrenamiento_screen.dart';

class EntrenarScreen extends StatefulWidget {
  final Usuario usuario;

  const EntrenarScreen({super.key, required this.usuario});

  @override
  State<EntrenarScreen> createState() => _EntrenarScreenState();
}

class _EntrenarScreenState extends State<EntrenarScreen> {
  final ApiService _apiService = ApiService();
  List<PlantillaEntrenamiento> _plantillas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarPlantillas();
  }

  Future<void> _cargarPlantillas() async {
    setState(() => _isLoading = true);
    try {
      final plantillas = await _apiService.getPlantillasPorUsuario(widget.usuario.id!);
      setState(() {
        _plantillas = plantillas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _iniciarEntrenamiento(PlantillaEntrenamiento plantilla) async {
    try {
      // Cargar la plantilla completa con ejercicios
      final plantillaCompleta = await _apiService.getPlantilla(plantilla.id!);

      if (plantillaCompleta.ejercicios == null || plantillaCompleta.ejercicios!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La plantilla no tiene ejercicios')),
          );
        }
        return;
      }

      // Crear el entrenamiento
      final entrenamiento = Entrenamiento(
        nombre: plantillaCompleta.nombre,
        descripcion: plantillaCompleta.descripcion,
        usuarioId: widget.usuario.id!,
        fechaRealizacion: DateTime.now(),
      );

      final entrenamientoCreado = await _apiService.crearEntrenamiento(entrenamiento);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SesionEntrenamientoScreen(
              entrenamientoId: entrenamientoCreado.id!,
              plantilla: plantillaCompleta,
              usuario: widget.usuario,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenar'),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _plantillas.isEmpty
              ? const Center(
                  child: Text('No hay plantillas. Crea una primero.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona una plantilla:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _plantillas.length,
                          itemBuilder: (context, index) {
                            final plantilla = _plantillas[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.play_arrow, color: Colors.white),
                                ),
                                title: Text(plantilla.nombre),
                                subtitle: Text(plantilla.descripcion ?? 'Sin descripción'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _iniciarEntrenamiento(plantilla),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
