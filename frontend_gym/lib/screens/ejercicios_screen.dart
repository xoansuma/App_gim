import 'package:flutter/material.dart';
import '../models/ejercicio.dart';
import '../services/api_service.dart';

class EjerciciosScreen extends StatefulWidget {
  const EjerciciosScreen({super.key});

  @override
  State<EjerciciosScreen> createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  final ApiService _apiService = ApiService();
  List<Ejercicio> _ejercicios = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarEjercicios();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarEjercicios() async {
    setState(() => _isLoading = true);
    try {
      final ejercicios = await _apiService.getEjercicios();
      setState(() {
        _ejercicios = ejercicios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ejercicios: $e')),
        );
      }
    }
  }

  Future<void> _buscarEjercicios(String query) async {
    if (query.isEmpty) {
      _cargarEjercicios();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ejercicios = await _apiService.buscarEjerciciosPorNombre(query);
      setState(() {
        _ejercicios = ejercicios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar: $e')),
        );
      }
    }
  }

  Future<void> _eliminarEjercicio(int id) async {
    try {
      await _apiService.eliminarEjercicio(id);
      _cargarEjercicios();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ejercicio eliminado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  void _mostrarFormulario({Ejercicio? ejercicio}) {
    final esEdicion = ejercicio != null;
    final nombreController = TextEditingController(text: ejercicio?.nombre ?? '');
    final grupoController = TextEditingController(text: ejercicio?.grupoMuscular ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(esEdicion ? 'Editar Ejercicio' : 'Nuevo Ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej: Press Banca',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: grupoController,
              decoration: const InputDecoration(
                labelText: 'Grupo Muscular',
                hintText: 'Ej: Pecho',
              ),
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
              if (nombreController.text.isEmpty || grupoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa todos los campos')),
                );
                return;
              }

              final nuevoEjercicio = Ejercicio(
                nombre: nombreController.text,
                grupoMuscular: grupoController.text,
              );

              try {
                if (esEdicion) {
                  await _apiService.actualizarEjercicio(ejercicio.id!, nuevoEjercicio);
                } else {
                  await _apiService.crearEjercicio(nuevoEjercicio);
                }
                if (mounted) {
                  Navigator.pop(context);
                  _cargarEjercicios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(esEdicion ? 'Ejercicio actualizado' : 'Ejercicio creado')),
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
            child: Text(esEdicion ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar ejercicio...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _cargarEjercicios();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _buscarEjercicios(value);
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _cargarEjercicios,
                    child: _ejercicios.isEmpty
                        ? const Center(child: Text('No hay ejercicios'))
                        : ListView.builder(
                            itemCount: _ejercicios.length,
                            itemBuilder: (context, index) {
                              final ejercicio = _ejercicios[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.fitness_center),
                                  ),
                                  title: Text(ejercicio.nombre),
                                  subtitle: Text(ejercicio.grupoMuscular),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _mostrarFormulario(ejercicio: ejercicio),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Confirmar'),
                                              content: const Text('¿Eliminar este ejercicio?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Cancelar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _eliminarEjercicio(ejercicio.id!);
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
