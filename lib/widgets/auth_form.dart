import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // Asegúrate de que la ruta sea correcta

class AuthForm extends StatefulWidget {
  // Actualizamos la firma de la función para recibir el dato del rol
  final void Function(
    String email,
    String password,
    bool isLogin,
    bool isTherapist, // <--- NUEVO CAMPO
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPassword = '';
  var _isTherapist = false; // <--- Variable para guardar si activó el switch

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Cierra el teclado

    if (isValid) {
      _formKey.currentState!.save();

      // Enviamos los 4 datos a la pantalla de AuthScreen
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin,
        _isTherapist, // <--- Enviamos la elección del usuario
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // 1. CAMPO EMAIL
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Por favor, ingresa un correo válido.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),

                const SizedBox(height: 12),

                // 2. CAMPO PASSWORD
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Mínimo 6 caracteres.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),

                const SizedBox(height: 20),

                // 3. SWITCH DE TERAPEUTA (Solo visible en Registro)
                if (!_isLogin)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD), // Azul muy clarito
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                    ),
                    child: SwitchListTile(
                      activeColor: AppTheme.primary,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      title: const Text(
                        'Soy Especialista / Terapeuta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      subtitle: const Text(
                        'Activa esto para acceder al panel de monitoreo.',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: _isTherapist,
                      onChanged: (bool value) {
                        setState(() {
                          _isTherapist = value;
                        });
                      },
                    ),
                  ),

                // 4. BOTONES DE ACCIÓN
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  SizedBox(
                    width: double.infinity, // Botón ancho completo
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _trySubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        // Importante: Si cambiamos a Login, reseteamos el switch a false
                        if (_isLogin) _isTherapist = false;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? '¿No tienes cuenta? Regístrate aquí'
                          : '¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
