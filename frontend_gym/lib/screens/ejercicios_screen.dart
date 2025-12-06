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
        _showError('Error al cargar ejercicios: $e');
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
        _showError('Error al buscar: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _eliminarEjercicio(int id) async {
    try {
      await _apiService.eliminarEjercicio(id);
      _cargarEjercicios();
      if (mounted) {
        _showSuccess('Ejercicio eliminado');
      }
    } catch (e) {
      if (mounted) {
        _showError('Error al eliminar: $e');
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
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: grupoController,
              decoration: const InputDecoration(
                labelText: 'Grupo Muscular',
                hintText: 'Ej: Pecho',
                border: OutlineInputBorder(),
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
                _showError('Completa todos los campos');
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
                  _showSuccess(esEdicion ? 'Ejercicio actualizado' : 'Ejercicio creado');
                }
              } catch (e) {
                if (mounted) {
                  _showError('Error: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text(esEdicion ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(int ejercicioId) {
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
              _eliminarEjercicio(ejercicioId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
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
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                border: const OutlineInputBorder(),
              ),
              onChanged: _buscarEjercicios,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _cargarEjercicios,
                    child: _ejercicios.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay ejercicios',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: _ejercicios.length,
                            itemBuilder: (context, index) {
                              final ejercicio = _ejercicios[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    child: const Icon(
                                      Icons.fitness_center,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    ejercicio.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(ejercicio.grupoMuscular),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _mostrarFormulario(ejercicio: ejercicio),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _confirmarEliminar(ejercicio.id!),
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
    );
  }
}
