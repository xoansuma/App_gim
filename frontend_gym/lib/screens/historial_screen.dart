import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/usuario.dart';
import '../models/entrenamiento.dart';
import '../services/api_service.dart';

class HistorialScreen extends StatefulWidget {
  final Usuario usuario;

  const HistorialScreen({super.key, required this.usuario});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final ApiService _apiService = ApiService();
  List<Entrenamiento> _entrenamientos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() => _isLoading = true);
    try {
      final entrenamientos = await _apiService.getEntrenamientosPorUsuario(widget.usuario.id!);
      setState(() {
        _entrenamientos = entrenamientos;
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

  Future<void> _verDetalle(int entrenamientoId) async {
    try {
      final entrenamiento = await _apiService.getEntrenamiento(entrenamientoId);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entrenamiento.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  if (entrenamiento.fechaRealizacion != null)
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(entrenamiento.fechaRealizacion!),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: entrenamiento.ejercicios?.length ?? 0,
                      itemBuilder: (context, index) {
                        final ejercicio = entrenamiento.ejercicios![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            title: Text(ejercicio.ejercicioNombre ?? 'Ejercicio'),
                            subtitle: Text(ejercicio.ejercicioGrupoMuscular ?? ''),
                            children: [
                              if (ejercicio.series != null && ejercicio.series!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: ejercicio.series!.map((serie) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          'Serie ${serie.numeroSerie}: ${serie.repeticiones} reps${serie.peso != null ? " × ${serie.peso} kg" : ""}',
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              else
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Sin series registradas'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
        title: const Text('Historial'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarHistorial,
              child: _entrenamientos.isEmpty
                  ? const Center(child: Text('No hay entrenamientos registrados'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _entrenamientos.length,
                      itemBuilder: (context, index) {
                        final entrenamiento = _entrenamientos[index];
                        final fecha = entrenamiento.fechaRealizacion != null
                            ? DateFormat('dd/MM/yyyy HH:mm').format(entrenamiento.fechaRealizacion!)
                            : 'Sin fecha';

                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.fitness_center, color: Colors.white),
                            ),
                            title: Text(entrenamiento.nombre),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (entrenamiento.descripcion != null)
                                  Text(entrenamiento.descripcion!),
                                Text(
                                  fecha,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _verDetalle(entrenamiento.id!),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
