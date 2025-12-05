import 'package:flutter/cupertino.dart';
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
        _showError('Error: $e');
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

  Future<void> _eliminarPlantilla(int id) async {
    try {
      await _apiService.eliminarPlantilla(id);
      _cargarPlantillas();
      if (mounted) {
        _showSuccess('Plantilla eliminada');
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    }
  }

  void _crearPlantilla() {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Nueva Plantilla'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: nombreController,
                placeholder: 'Nombre',
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: descripcionController,
                placeholder: 'Descripción',
                padding: const EdgeInsets.all(12),
                maxLines: 2,
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
              if (nombreController.text.isEmpty) {
                _showError('El nombre es requerido');
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
                    CupertinoPageRoute(
                      builder: (context) => PlantillaDetalleScreen(
                        plantillaId: creada.id!,
                        usuario: widget.usuario,
                      ),
                    ),
                  ).then((_) => _cargarPlantillas());
                }
              } catch (e) {
                if (mounted) {
                  _showError('Error: $e');
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(int plantillaId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar esta plantilla?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _eliminarPlantilla(plantillaId);
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
        middle: const Text('Mis Plantillas'),
        backgroundColor: CupertinoColors.systemOrange,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled_solid, size: 30),
          onPressed: _crearPlantilla,
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _cargarPlantillas,
                  ),
                  _plantillas.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No hay plantillas. Crea una nueva.',
                              style: TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final plantilla = _plantillas[index];
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
                                          color: CupertinoColors.systemOrange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.list_bullet,
                                          color: CupertinoColors.white,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        plantilla.nombre,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(plantilla.descripcion ?? 'Sin descripción'),
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
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) => PlantillaDetalleScreen(
                                                    plantillaId: plantilla.id!,
                                                    usuario: widget.usuario,
                                                  ),
                                                ),
                                              ).then((_) => _cargarPlantillas());
                                            },
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: const Icon(
                                              CupertinoIcons.trash_circle_fill,
                                              color: CupertinoColors.systemRed,
                                              size: 32,
                                            ),
                                            onPressed: () => _confirmarEliminar(plantilla.id!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: _plantillas.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
