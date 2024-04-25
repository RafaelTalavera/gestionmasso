import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../sign_in/sign_in_view.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/users';

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late String _username = '';

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> formData = Map.from(_formKey.currentState!.value);

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Agrega el campo "role" con el valor "ADMINISTRATOR"
      formData["role"] = "ADMINISTRATOR";

      final responsePost = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (responsePost.statusCode == 201) {
        print('Información enviada correctamente.');

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hola $_username bienvenio!!!'),
              content: const Text(
                  'La identificación se creó correctamente. Ya podes usar Gestión Masso'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInView(),
                      ),
                    );
                  },
                  child: const Text('Volver a inicio'),
                ),
              ],
            );
          },
        );
      } else {
        print(
          'Error al enviar la información. Código de respuesta: ${responsePost.statusCode}',
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error al enviar la información. Por favor, inténtelo de nuevo.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/imagen/gmasso.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Alta de usuario',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 238, 183, 19),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                          labelText: 'Escriba su username',
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _username = value ??
                                ''; // Usa el operador de navegación segura para manejar nulos
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'password',
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Escriba aquí su password',
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'confirmPassword',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirme su password',
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Escriba aquí su email',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'El campo no puede estar vacío',
                          ),
                          FormBuilderValidators.email(
                            errorText:
                                'El formato del correo electrónico no es válido',
                          ),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'phone',
                        decoration: const InputDecoration(
                          labelText: 'Escriba aquí su número de teléfono',
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'fullname',
                        decoration: const InputDecoration(
                          labelText: 'Escriba aquí su nombre completo',
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                      ),
                      // Agrega aquí más campos si es necesario
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Enviar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInView(),
                  ),
                );
              },
              child: const Text('Ir a Login'),
            ),
          ],
        ),
      ),
    );
  }
}
