import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entrenamiento.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'entrenamiento_detalle_screen.dart';

class EntrenamientosScreen extends StatefulWidget {
  const EntrenamientosScreen({super.key});

  @override
  State<EntrenamientosScreen> createState() => _EntrenamientosScreenState();
}

class _EntrenamientosScreenState extends State<EntrenamientosScreen> {
  final ApiService _apiService = ApiService();
  List<Entrenamiento> _entrenamientos = [];
  List<Usuario> _usuarios = [];
  Usuario? _usuarioSeleccionado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final usuarios = await _apiService.getUsuarios();
      setState(() {
        _usuarios = usuarios;
        if (usuarios.isNotEmpty && _usuarioSeleccionado == null) {
          _usuarioSeleccionado = usuarios.first;
        }
        _isLoading = false;
      });
      if (_usuarioSeleccionado != null) {
        _cargarEntrenamientosUsuario(_usuarioSeleccionado!.id!);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _cargarEntrenamientosUsuario(int usuarioId) async {
    setState(() => _isLoading = true);
    try {
      final entrenamientos = await _apiService.getEntrenamientosPorUsuario(usuarioId);
      setState(() {
        _entrenamientos = entrenamientos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar entrenamientos: $e')),
        );
      }
    }
  }

  Future<void> _eliminarEntrenamiento(int id) async {
    try {
      await _apiService.eliminarEntrenamiento(id);
      if (_usuarioSeleccionado != null) {
        _cargarEntrenamientosUsuario(_usuarioSeleccionado!.id!);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entrenamiento eliminado')),
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

  void _mostrarFormularioCrear() {
    if (_usuarioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero crea un usuario')),
      );
      return;
    }

    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Entrenamiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej: Rutina Pecho y Tríceps',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 3,
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

              final nuevoEntrenamiento = Entrenamiento(
                nombre: nombreController.text,
                descripcion: descripcionController.text.isEmpty ? null : descripcionController.text,
                usuarioId: _usuarioSeleccionado!.id!,
                fechaRealizacion: DateTime.now(),
              );

              try {
                final creado = await _apiService.crearEntrenamiento(nuevoEntrenamiento);
                if (mounted) {
                  Navigator.pop(context);
                  _cargarEntrenamientosUsuario(_usuarioSeleccionado!.id!);

                  // Navegar a la pantalla de detalle para agregar ejercicios
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntrenamientoDetalleScreen(
                        entrenamientoId: creado.id!,
                      ),
                    ),
                  ).then((_) => _cargarEntrenamientosUsuario(_usuarioSeleccionado!.id!));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entrenamiento creado. Agrega ejercicios.')),
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
        title: const Text('Entrenamientos'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          if (_usuarios.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Usuario: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: DropdownButton<Usuario>(
                          isExpanded: true,
                          value: _usuarioSeleccionado,
                          items: _usuarios.map((usuario) {
                            return DropdownMenuItem(
                              value: usuario,
                              child: Text(usuario.nombre),
                            );
                          }).toList(),
                          onChanged: (usuario) {
                            setState(() => _usuarioSeleccionado = usuario);
                            if (usuario != null) {
                              _cargarEntrenamientosUsuario(usuario.id!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _usuarioSeleccionado != null
                        ? _cargarEntrenamientosUsuario(_usuarioSeleccionado!.id!)
                        : _cargarDatos(),
                    child: _entrenamientos.isEmpty
                        ? const Center(child: Text('No hay entrenamientos'))
                        : ListView.builder(
                            itemCount: _entrenamientos.length,
                            itemBuilder: (context, index) {
                              final entrenamiento = _entrenamientos[index];
                              final fecha = entrenamiento.fechaRealizacion != null
                                  ? DateFormat('dd/MM/yyyy HH:mm')
                                      .format(entrenamiento.fechaRealizacion!)
                                  : 'Sin fecha';

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.assignment),
                                  ),
                                  title: Text(entrenamiento.nombre),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (entrenamiento.descripcion != null)
                                        Text(entrenamiento.descripcion!),
                                      Text(fecha, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EntrenamientoDetalleScreen(
                                                entrenamientoId: entrenamiento.id!,
                                              ),
                                            ),
                                          ).then((_) => _cargarEntrenamientosUsuario(
                                              _usuarioSeleccionado!.id!));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Confirmar'),
                                              content: const Text('¿Eliminar este entrenamiento?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Cancelar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _eliminarEntrenamiento(entrenamiento.id!);
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
        onPressed: _mostrarFormularioCrear,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
