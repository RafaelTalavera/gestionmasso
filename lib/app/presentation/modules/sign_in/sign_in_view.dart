import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../routes/routes.dart';
import '../../../../main.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  bool _fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(() {
                        _username = text.trim().toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'username',
                    ),
                    validator: (text) {
                      text = text?.trim().toLowerCase() ?? '';

                      if (text.isEmpty) {
                        return 'Invalid username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(() {
                        _password = text.replaceAll(' ', '').toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    validator: (text) {
                      text = text?.replaceAll(' ', '').toLowerCase() ?? '';

                      if (text.length < 4) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    if (_fetching) {
                      return const CircularProgressIndicator();
                    }
                    return MaterialButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          _submit(context);
                        }
                      },
                      color: Colors.blue,
                      child: const Text('Sign in'),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });

    try {
      final result = await Injector.of(context).authenticationRepository.signIn(
            _username,
            _password,
          );

      result.when(
        (failure) {
          setState(() {
            _fetching = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error en la autenticación'),
            ),
          );
        },
        (user) async {
          // Extraer el token del usuario o realizar cualquier lógica adicional
          final token = user.token; // Ajusta esto según tu implementación real

          // Guardar el token en un lugar seguro, por ejemplo, FlutterSecureStorage
          await _saveToken(context, token);

          setState(() {
            _fetching = false;
          });

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, Routes.home);
        },
      );
    } catch (e) {
      setState(() {
        _fetching = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en la autenticación'),
        ),
      );
    }
  }

  Future<void> _saveToken(BuildContext context, String token) async {
    const storage = FlutterSecureStorage();

    try {
      // Guardar el token en el almacenamiento seguro
      await storage.write(key: 'authToken', value: token);
    } catch (e) {
      throw Exception('Error al guardar el token');
    }
  }
}
