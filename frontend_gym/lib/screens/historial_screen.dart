import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/usuario.dart';
import '../models/entrenamiento.dart';
import '../services/api_service.dart';

class HistorialScreen extends StatefulWidget {
  final Usuario usuario;

  const HistorialScreen({super.key, required this.usuario});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final ApiService _apiService = ApiService();
  List<Entrenamiento> _entrenamientos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() => _isLoading = true);
    try {
      final entrenamientos = await _apiService.getEntrenamientosPorUsuario(widget.usuario.id!);
      setState(() {
        _entrenamientos = entrenamientos;
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

  Future<void> _verDetalle(int entrenamientoId) async {
    try {
      final entrenamiento = await _apiService.getEntrenamiento(entrenamientoId);

      if (mounted) {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(entrenamiento.nombre),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entrenamiento.fechaRealizacion != null)
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(entrenamiento.fechaRealizacion!),
                        style: const TextStyle(
                          color: CupertinoColors.secondaryLabel,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: entrenamiento.ejercicios?.length ?? 0,
                        itemBuilder: (context, index) {
                          final ejercicio = entrenamiento.ejercicios![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                CupertinoListTile(
                                  title: Text(
                                    ejercicio.ejercicioNombre ?? 'Ejercicio',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(ejercicio.ejercicioGrupoMuscular ?? ''),
                                ),
                                if (ejercicio.series != null && ejercicio.series!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: ejercicio.series!.map((serie) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            'Serie ${serie.numeroSerie}: ${serie.repeticiones} reps${serie.peso != null ? " × ${serie.peso} kg" : ""}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: CupertinoColors.secondaryLabel,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                else
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    child: Text(
                                      'Sin series registradas',
                                      style: TextStyle(color: CupertinoColors.systemGrey),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
        middle: Text('Historial'),
        backgroundColor: CupertinoColors.systemGreen,
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _cargarHistorial,
                  ),
                  _entrenamientos.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No hay entrenamientos registrados',
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
                                final entrenamiento = _entrenamientos[index];
                                final fecha = entrenamiento.fechaRealizacion != null
                                    ? DateFormat('dd/MM/yyyy HH:mm').format(entrenamiento.fechaRealizacion!)
                                    : 'Sin fecha';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _verDetalle(entrenamiento.id!),
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
                                                color: CupertinoColors.systemGreen,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                CupertinoIcons.flame_fill,
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
                                                    entrenamiento.nombre,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      color: CupertinoColors.label,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  if (entrenamiento.descripcion != null)
                                                    Text(
                                                      entrenamiento.descripcion!,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: CupertinoColors.secondaryLabel,
                                                      ),
                                                    ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    fecha,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: CupertinoColors.systemGrey,
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
                              childCount: _entrenamientos.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
