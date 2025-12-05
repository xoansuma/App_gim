import 'package:flutter/cupertino.dart';
import '../models/usuario.dart';
import 'plantillas_screen.dart';
import 'entrenar_screen.dart';
import 'historial_screen.dart';
import 'ejercicios_screen.dart';
import 'login_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final Usuario usuario;

  const MainMenuScreen({super.key, required this.usuario});

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Hola, ${usuario.nombre}'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.square_arrow_right),
          onPressed: () => _showLogoutDialog(context),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 20),
            const Icon(
              CupertinoIcons.sportscourt_fill,
              size: 80,
              color: CupertinoColors.systemBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gym App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuCard(
              context,
              'Historial',
              'Ver entrenamientos pasados',
              CupertinoIcons.clock_fill,
              CupertinoColors.systemGreen,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HistorialScreen(usuario: usuario),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              'Plantillas',
              'Crear y editar plantillas de entrenamiento',
              CupertinoIcons.list_bullet,
              CupertinoColors.systemOrange,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PlantillasScreen(usuario: usuario),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              'Entrenar',
              'Iniciar una sesión de entrenamiento',
              CupertinoIcons.play_circle_fill,
              CupertinoColors.systemRed,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => EntrenarScreen(usuario: usuario),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              'Ejercicios',
              'Gestionar catálogo de ejercicios',
              CupertinoIcons.flame_fill,
              CupertinoColors.systemPurple,
              () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const EjerciciosScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
    );
  }
}
