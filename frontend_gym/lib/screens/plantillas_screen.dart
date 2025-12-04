import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/plantilla_entrenamiento.dart';
import '../services/api_service.dart';
import 'plantilla_detalle_screen.dart';

class PlantillasScreen extends StatefulWidget {
  final Usuario usuario;

  const PlantillasScreen({super.key, required this.usuario});

  @override
  State<PlantillasScreen> createState() => _PlantillasScreenState();
}

class _PlantillasScreenState extends State<PlantillasScreen> {
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

  Future<void> _eliminarPlantilla(int id) async {
    try {
      await _apiService.eliminarPlantilla(id);
      _cargarPlantillas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plantilla eliminada')),
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

  void _crearPlantilla() {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Plantilla'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
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
              if (nombreController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre es requerido')),
                );
                return;
              }

              final plantilla = PlantillaEntrenamiento(
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                usuarioId: widget.usuario.id!,
              );

              try {
                final creada = await _apiService.crearPlantilla(plantilla);
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantillaDetalleScreen(
                        plantillaId: creada.id!,
                        usuario: widget.usuario,
                      ),
                    ),
                  ).then((_) => _cargarPlantillas());
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Plantillas'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarPlantillas,
              child: _plantillas.isEmpty
                  ? const Center(child: Text('No hay plantillas. Crea una nueva.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _plantillas.length,
                      itemBuilder: (context, index) {
                        final plantilla = _plantillas[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.list_alt),
                            ),
                            title: Text(plantilla.nombre),
                            subtitle: Text(plantilla.descripcion ?? 'Sin descripción'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlantillaDetalleScreen(
                                          plantillaId: plantilla.id!,
                                          usuario: widget.usuario,
                                        ),
                                      ),
                                    ).then((_) => _cargarPlantillas());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar'),
                                        content: const Text('¿Eliminar esta plantilla?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _eliminarPlantilla(plantilla.id!);
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearPlantilla,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
