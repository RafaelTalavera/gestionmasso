import 'package:flutter/material.dart';
import 'package:gestionmasso/app/domain/enums.dart';
import 'package:gestionmasso/app/presentation/routes/routes.dart';
import 'package:gestionmasso/main.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

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
    final result = await Injector.of(context).authenticationRepository.signIn(
          _username,
          _password,
        );

    if (!mounted) {
      return;
    }

    result.when(
      (failure) {
        setState(() {
          _fetching = false;
        });
        final message = {
          SignInFailure.notFound: 'Not Found',
          SignInFailure.unauthorized: 'Invalid password',
          SignInFailure.unknown: 'Error',
        }[failure];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
      (user) {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }
}
