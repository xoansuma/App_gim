import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/plantilla_entrenamiento.dart';
import '../models/ejercicio.dart';
import '../services/api_service.dart';
import 'ejercicios_screen.dart';

class PlantillaDetalleScreen extends StatefulWidget {
  final int plantillaId;
  final Usuario usuario;

  const PlantillaDetalleScreen({
    super.key,
    required this.plantillaId,
    required this.usuario,
  });

  @override
  State<PlantillaDetalleScreen> createState() => _PlantillaDetalleScreenState();
}

class _PlantillaDetalleScreenState extends State<PlantillaDetalleScreen> {
  final ApiService _apiService = ApiService();
  PlantillaEntrenamiento? _plantilla;
  List<Ejercicio> _ejerciciosDisponibles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final plantilla = await _apiService.getPlantilla(widget.plantillaId);
      final ejercicios = await _apiService.getEjercicios();
      setState(() {
        _plantilla = plantilla;
        _ejerciciosDisponibles = ejercicios;
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

  Future<void> _agregarEjercicio() async {
    if (_ejerciciosDisponibles.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No hay ejercicios'),
          content: const Text('Primero debes crear ejercicios. ¿Quieres ir a la pantalla de ejercicios?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EjerciciosScreen(),
                  ),
                ).then((_) => _cargarDatos());
              },
              child: const Text('Ir a Ejercicios'),
            ),
          ],
        ),
      );
      return;
    }

    Ejercicio? ejercicioSeleccionado = _ejerciciosDisponibles.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Agregar Ejercicio'),
          content: DropdownButton<Ejercicio>(
            isExpanded: true,
            value: ejercicioSeleccionado,
            items: _ejerciciosDisponibles.map((ej) {
              return DropdownMenuItem(
                value: ej,
                child: Text('${ej.nombre} (${ej.grupoMuscular})'),
              );
            }).toList(),
            onChanged: (value) {
              setDialogState(() => ejercicioSeleccionado = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final orden = (_plantilla?.ejercicios?.length ?? 0) + 1;
                final plantillaEjercicio = PlantillaEjercicio(
                  plantillaId: widget.plantillaId,
                  ejercicioId: ejercicioSeleccionado!.id!,
                  orden: orden,
                );

                try {
                  await _apiService.agregarEjercicioAPlantilla(plantillaEjercicio);
                  if (mounted) {
                    Navigator.pop(context);
                    _cargarDatos();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_plantilla?.nombre ?? 'Plantilla'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _plantilla?.nombre ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_plantilla?.descripcion != null) ...[
                            const SizedBox(height: 8),
                            Text(_plantilla!.descripcion!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ejercicios',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EjerciciosScreen(),
                                ),
                              ).then((_) => _cargarDatos());
                            },
                            icon: const Icon(Icons.fitness_center),
                            label: const Text('Gestionar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _agregarEjercicio,
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_plantilla?.ejercicios == null || _plantilla!.ejercicios!.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: Text('No hay ejercicios. Agrega algunos.')),
                      ),
                    )
                  else
                    ..._plantilla!.ejercicios!.map((ej) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${ej.orden}')),
                          title: Text(ej.ejercicioNombre ?? 'Ejercicio'),
                          subtitle: Text(ej.ejercicioGrupoMuscular ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              try {
                                await _apiService.eliminarEjercicioDePlantilla(ej.id!);
                                _cargarDatos();
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
