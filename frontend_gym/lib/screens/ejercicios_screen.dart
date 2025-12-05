import 'package:flutter/cupertino.dart';
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
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Éxito'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
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

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(esEdicion ? 'Editar Ejercicio' : 'Nuevo Ejercicio'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: nombreController,
                placeholder: 'Nombre (Ej: Press Banca)',
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: grupoController,
                placeholder: 'Grupo Muscular (Ej: Pecho)',
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
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
            child: Text(esEdicion ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(int ejercicioId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar este ejercicio?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _eliminarEjercicio(ejercicioId);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Ejercicios'),
        backgroundColor: CupertinoColors.systemPurple,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled_solid, size: 30),
          onPressed: () => _mostrarFormulario(),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Buscar ejercicio...',
                onChanged: _buscarEjercicios,
                onSuffixTap: () {
                  _searchController.clear();
                  _cargarEjercicios();
                },
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: _cargarEjercicios,
                        ),
                        _ejercicios.isEmpty
                            ? const SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'No hay ejercicios',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ),
                              )
                            : SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final ejercicio = _ejercicios[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemBackground.resolveFrom(context),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: CupertinoColors.systemGrey.withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: CupertinoListTile(
                                            leading: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: CupertinoColors.systemPurple,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                CupertinoIcons.flame_fill,
                                                color: CupertinoColors.white,
                                                size: 24,
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
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  child: const Icon(
                                                    CupertinoIcons.pencil_circle_fill,
                                                    color: CupertinoColors.systemBlue,
                                                    size: 32,
                                                  ),
                                                  onPressed: () => _mostrarFormulario(ejercicio: ejercicio),
                                                ),
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  child: const Icon(
                                                    CupertinoIcons.trash_circle_fill,
                                                    color: CupertinoColors.systemRed,
                                                    size: 32,
                                                  ),
                                                  onPressed: () => _confirmarEliminar(ejercicio.id!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: _ejercicios.length,
                                  ),
                                ),
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
