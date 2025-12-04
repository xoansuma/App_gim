import 'package:flutter/material.dart';
import '../models/entrenamiento.dart';
import '../models/ejercicio.dart';
import '../services/api_service.dart';

class EntrenamientoDetalleScreen extends StatefulWidget {
  final int entrenamientoId;

  const EntrenamientoDetalleScreen({
    super.key,
    required this.entrenamientoId,
  });

  @override
  State<EntrenamientoDetalleScreen> createState() => _EntrenamientoDetalleScreenState();
}

class _EntrenamientoDetalleScreenState extends State<EntrenamientoDetalleScreen> {
  final ApiService _apiService = ApiService();
  Entrenamiento? _entrenamiento;
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
      final entrenamiento = await _apiService.getEntrenamiento(widget.entrenamientoId);
      final ejercicios = await _apiService.getEjercicios();
      setState(() {
        _entrenamiento = entrenamiento;
        _ejerciciosDisponibles = ejercicios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _agregarEjercicio() async {
    if (_ejerciciosDisponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero crea algunos ejercicios')),
      );
      return;
    }

    Ejercicio? ejercicioSeleccionado = _ejerciciosDisponibles.first;
    final notasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ejercicio'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Ejercicio>(
                value: ejercicioSeleccionado,
                decoration: const InputDecoration(labelText: 'Ejercicio'),
                items: _ejerciciosDisponibles.map((ejercicio) {
                  return DropdownMenuItem(
                    value: ejercicio,
                    child: Text('${ejercicio.nombre} (${ejercicio.grupoMuscular})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() => ejercicioSeleccionado = value);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notasController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (ejercicioSeleccionado == null) return;

              final orden = (_entrenamiento?.ejercicios?.length ?? 0) + 1;

              final ejercicioEntrenamiento = EjercicioEntrenamiento(
                entrenamientoId: widget.entrenamientoId,
                ejercicioId: ejercicioSeleccionado!.id!,
                orden: orden,
                notas: notasController.text.isEmpty ? null : notasController.text,
              );

              try {
                await _apiService.agregarEjercicioAEntrenamiento(ejercicioEntrenamiento);
                if (mounted) {
                  Navigator.pop(context);
                  _cargarDatos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ejercicio agregado')),
                  );
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
    );
  }

  Future<void> _eliminarEjercicioDeEntrenamiento(int ejercicioEntrenamientoId) async {
    try {
      await _apiService.eliminarEjercicioDeEntrenamiento(ejercicioEntrenamientoId);
      _cargarDatos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ejercicio eliminado del entrenamiento')),
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

  Future<void> _agregarSerie(EjercicioEntrenamiento ejercicioEntrenamiento) async {
    final repeticionesController = TextEditingController();
    final pesoController = TextEditingController();
    final notasController = TextEditingController();

    final numeroSerie = (ejercicioEntrenamiento.series?.length ?? 0) + 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Serie $numeroSerie - ${ejercicioEntrenamiento.ejercicioNombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repeticionesController,
              decoration: const InputDecoration(labelText: 'Repeticiones'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                hintText: 'Opcional',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notasController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (repeticionesController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las repeticiones son requeridas')),
                );
                return;
              }

              final serie = Serie(
                ejercicioEntrenamientoId: ejercicioEntrenamiento.id,
                numeroSerie: numeroSerie,
                repeticiones: int.parse(repeticionesController.text),
                peso: pesoController.text.isEmpty ? null : double.parse(pesoController.text),
                notas: notasController.text.isEmpty ? null : notasController.text,
              );

              try {
                await _apiService.crearSerie(serie);
                if (mounted) {
                  Navigator.pop(context);
                  _cargarDatos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Serie registrada')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_entrenamiento?.nombre ?? 'Detalle'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _entrenamiento == null
              ? const Center(child: Text('Error al cargar entrenamiento'))
              : RefreshIndicator(
                  onRefresh: _cargarDatos,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _entrenamiento!.nombre,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_entrenamiento!.descripcion != null) ...[
                                    const SizedBox(height: 8),
                                    Text(_entrenamiento!.descripcion!),
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
                              ElevatedButton.icon(
                                onPressed: _agregarEjercicio,
                                icon: const Icon(Icons.add),
                                label: const Text('Agregar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_entrenamiento!.ejercicios == null ||
                              _entrenamiento!.ejercicios!.isEmpty)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text('No hay ejercicios. Agrega algunos.'),
                                ),
                              ),
                            )
                          else
                            ..._entrenamiento!.ejercicios!.map((ejercicioEnt) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  title: Text(
                                    ejercicioEnt.ejercicioNombre ?? 'Ejercicio',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    ejercicioEnt.ejercicioGrupoMuscular ?? '',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirmar'),
                                          content: const Text(
                                              '¿Eliminar este ejercicio del entrenamiento?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _eliminarEjercicioDeEntrenamiento(
                                                    ejercicioEnt.id!);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (ejercicioEnt.notas != null) ...[
                                            Text('Notas: ${ejercicioEnt.notas}'),
                                            const Divider(),
                                          ],
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Series:',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () => _agregarSerie(ejercicioEnt),
                                                icon: const Icon(Icons.add, size: 16),
                                                label: const Text('Serie'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 12, vertical: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          if (ejercicioEnt.series == null ||
                                              ejercicioEnt.series!.isEmpty)
                                            const Text('No hay series registradas')
                                          else
                                            ...ejercicioEnt.series!.map((serie) {
                                              return Card(
                                                color: Colors.blue[50],
                                                child: ListTile(
                                                  dense: true,
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.blue,
                                                    child: Text(
                                                      '${serie.numeroSerie}',
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    '${serie.repeticiones} reps${serie.peso != null ? " × ${serie.peso} kg" : ""}',
                                                  ),
                                                  subtitle: serie.notas != null
                                                      ? Text(serie.notas!)
                                                      : null,
                                                ),
                                              );
                                            }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
