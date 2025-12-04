import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/plantilla_entrenamiento.dart';
import '../models/entrenamiento.dart';
import '../services/api_service.dart';

class SesionEntrenamientoScreen extends StatefulWidget {
  final int entrenamientoId;
  final PlantillaEntrenamiento plantilla;
  final Usuario usuario;

  const SesionEntrenamientoScreen({
    super.key,
    required this.entrenamientoId,
    required this.plantilla,
    required this.usuario,
  });

  @override
  State<SesionEntrenamientoScreen> createState() => _SesionEntrenamientoScreenState();
}

class _SesionEntrenamientoScreenState extends State<SesionEntrenamientoScreen> {
  final ApiService _apiService = ApiService();
  final Map<int, List<EjercicioEntrenamiento>> _ejerciciosRegistrados = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    setState(() => _isLoading = true);
    try {
      // Agregar ejercicios de la plantilla al entrenamiento
      for (var plantillaEj in widget.plantilla.ejercicios!) {
        final ejercicioEnt = EjercicioEntrenamiento(
          entrenamientoId: widget.entrenamientoId,
          ejercicioId: plantillaEj.ejercicioId,
          orden: plantillaEj.orden,
          notas: plantillaEj.notas,
        );
        final creado = await _apiService.agregarEjercicioAEntrenamiento(ejercicioEnt);
        _ejerciciosRegistrados[plantillaEj.ejercicioId] = [creado];
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _agregarSerie(PlantillaEjercicio plantillaEj) async {
    final repeticionesController = TextEditingController();
    final pesoController = TextEditingController();

    final ejercicioEnt = _ejerciciosRegistrados[plantillaEj.ejercicioId]!.first;
    final numeroSerie = (await _cargarSeriesDeEjercicio(ejercicioEnt.id!)).length + 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Serie $numeroSerie - ${plantillaEj.ejercicioNombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repeticionesController,
              decoration: const InputDecoration(labelText: 'Repeticiones'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                ejercicioEntrenamientoId: ejercicioEnt.id,
                numeroSerie: numeroSerie,
                repeticiones: int.parse(repeticionesController.text),
                peso: pesoController.text.isEmpty ? null : double.parse(pesoController.text),
              );

              try {
                await _apiService.crearSerie(serie);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
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

  Future<List<Serie>> _cargarSeriesDeEjercicio(int ejercicioEntrenamientoId) async {
    try {
      return await _apiService.getSeriesDeEjercicioEntrenamiento(ejercicioEntrenamientoId);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plantilla.nombre),
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Finalizar entrenamiento'),
                  content: const Text('¿Deseas terminar el entrenamiento?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Entrenamiento guardado')),
                        );
                      },
                      child: const Text('Finalizar'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('FINALIZAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.plantilla.ejercicios!.length,
              itemBuilder: (context, index) {
                final plantillaEj = widget.plantilla.ejercicios![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plantillaEj.ejercicioNombre ?? 'Ejercicio',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(plantillaEj.ejercicioGrupoMuscular ?? ''),
                        const SizedBox(height: 12),
                        FutureBuilder<List<Serie>>(
                          future: _cargarSeriesDeEjercicio(
                            _ejerciciosRegistrados[plantillaEj.ejercicioId]!.first.id!,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final series = snapshot.data!;
                            return Column(
                              children: [
                                if (series.isNotEmpty)
                                  ...series.map((serie) => Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          'Serie ${serie.numeroSerie}: ${serie.repeticiones} reps${serie.peso != null ? " × ${serie.peso} kg" : ""}',
                                        ),
                                      )),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _agregarSerie(plantillaEj),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar Serie'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
