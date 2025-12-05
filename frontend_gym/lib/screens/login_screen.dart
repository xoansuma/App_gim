import 'package:flutter/cupertino.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'main_menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Por favor completa todos los campos');
      return;
    }

    if (!_isLogin && _nombreController.text.isEmpty) {
      _showError('El nombre es requerido');
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showError('Email inválido');
      return;
    }

    if (_passwordController.text.length < 4) {
      _showError('La contraseña debe tener al menos 4 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        final usuario = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => MainMenuScreen(usuario: usuario),
            ),
          );
        }
      } else {
        final nuevoUsuario = Usuario(
          email: _emailController.text,
          nombre: _nombreController.text,
          password: _passwordController.text,
        );
        await _apiService.crearUsuario(nuevoUsuario);
        if (mounted) {
          setState(() {
            _isLogin = true;
            _nombreController.clear();
            _isLoading = false;
          });
          _showSuccess('Usuario creado. Ahora inicia sesión');
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      CupertinoIcons.sportscourt_fill,
                      size: 80,
                      color: CupertinoColors.systemBlue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gym App',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                      style: const TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (!_isLogin) ...[
                      CupertinoTextField(
                        controller: _nombreController,
                        placeholder: 'Nombre',
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(CupertinoIcons.person_fill, color: CupertinoColors.systemGrey),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    CupertinoTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.mail_solid, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Contraseña',
                      obscureText: true,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.lock_fill, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton.filled(
                        onPressed: _isLoading ? null : _submit,
                        borderRadius: BorderRadius.circular(12),
                        child: _isLoading
                            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                            : Text(
                                _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
