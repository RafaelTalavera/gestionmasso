import 'package:flutter/material.dart';
import '../../../routes/routes.dart';
import '../../../../../main.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.orange,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(50),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Aquí puedes agregar widgets adicionales dentro del Drawer según tus necesidades
              Center(
                child: Container(
                  width: 300, // Ajusta el ancho según tus necesidades
                  height: 60, // Ajusta el alto según tus necesidades
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(
                        10), // Ajusta el radio de las esquinas según tus necesidades
                  ),
                  child: Center(
                    child: ListTile(
                      title: const Center(child: Text('Item 1')),
                      onTap: () {
                        // Acciones cuando se presiona el elemento del Drawer
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
                      // Otros atributos de formato según tus necesidades
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Acciones cuando se presiona el segundo elemento del Drawer
                },
              ),
              // Otros elementos del Drawer...
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Injector.of(context).authenticationRepository.singOut();
            Navigator.pushReplacementNamed(
              context,
              Routes.signIn,
            );
          },
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
