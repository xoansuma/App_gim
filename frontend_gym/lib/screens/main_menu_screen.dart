import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'plantillas_screen.dart';
import 'entrenar_screen.dart';
import 'historial_screen.dart';
import 'ejercicios_screen.dart';
import 'login_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final Usuario usuario;

  const MainMenuScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${usuario.nombre}'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Gym App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuCard(
                    context,
                    'Historial',
                    'Ver entrenamientos pasados',
                    Icons.history,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistorialScreen(usuario: usuario),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    'Plantillas',
                    'Crear y editar plantillas de entrenamiento',
                    Icons.list_alt,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantillasScreen(usuario: usuario),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    'Entrenar',
                    'Iniciar una sesión de entrenamiento',
                    Icons.play_arrow,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntrenarScreen(usuario: usuario),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    'Ejercicios',
                    'Gestionar catálogo de ejercicios',
                    Icons.fitness_center,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EjerciciosScreen(),
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

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
