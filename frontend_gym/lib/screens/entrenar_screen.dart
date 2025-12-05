import 'package:flutter/cupertino.dart';
import '../models/usuario.dart';
import '../models/plantilla_entrenamiento.dart';
import '../models/entrenamiento.dart';
import '../services/api_service.dart';
import 'sesion_entrenamiento_screen.dart';

class EntrenarScreen extends StatefulWidget {
  final Usuario usuario;

  const EntrenarScreen({super.key, required this.usuario});

  @override
  State<EntrenarScreen> createState() => _EntrenarScreenState();
}

class _EntrenarScreenState extends State<EntrenarScreen> {
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

  Future<void> _iniciarEntrenamiento(PlantillaEntrenamiento plantilla) async {
    try {
      final plantillaCompleta = await _apiService.getPlantilla(plantilla.id!);

      if (plantillaCompleta.ejercicios == null || plantillaCompleta.ejercicios!.isEmpty) {
        if (mounted) {
          _showError('La plantilla no tiene ejercicios');
        }
        return;
      }

      final entrenamiento = Entrenamiento(
        nombre: plantillaCompleta.nombre,
        descripcion: plantillaCompleta.descripcion,
        usuarioId: widget.usuario.id!,
        fechaRealizacion: DateTime.now(),
      );

      final entrenamientoCreado = await _apiService.crearEntrenamiento(entrenamiento);

      if (mounted) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SesionEntrenamientoScreen(
              entrenamientoId: entrenamientoCreado.id!,
              plantilla: plantillaCompleta,
              usuario: widget.usuario,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Entrenar'),
        backgroundColor: CupertinoColors.systemRed,
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _plantillas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay plantillas. Crea una primero.',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selecciona una plantilla:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.label,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _plantillas.length,
                            itemBuilder: (context, index) {
                              final plantilla = _plantillas[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _iniciarEntrenamiento(plantilla),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: CupertinoColors.systemRed,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.play_arrow_solid,
                                              color: CupertinoColors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  plantilla.nombre,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: CupertinoColors.label,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  plantilla.descripcion ?? 'Sin descripción',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: CupertinoColors.secondaryLabel,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_right,
                                            color: CupertinoColors.systemGrey3,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
}
