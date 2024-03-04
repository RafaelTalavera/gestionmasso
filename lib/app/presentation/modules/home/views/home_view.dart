import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../main.dart';


import '../../riesgos/views/riesgos_views.dart';
import '../../sign_in/sign_in_view.dart';
import 'validation/build_accident_module.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Bottom Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Directionality(
        textDirection: TextDirection.ltr,
        child: MyHomePage(title: ''),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title,
  });
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.warning,
      "Seguridad",
      const Color.fromARGB(33, 1, 1, 22),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      CupertinoIcons.arrow_3_trianglepath,
      "Ambiente",
      Colors.green,
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      CupertinoIcons.chart_bar_fill,
      "Reports",
      Colors.red,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.notifications,
      "Notifications",
      Colors.cyan,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/imagen/gmasso.png', // Ruta de tu imagen
              width: 40, // Ajusta el ancho según tus necesidades
              height: 40, // Ajusta la altura según tus necesidades
            ),
            const SizedBox(width: 10), // Espacio entre la imagen y el texto
            Text(widget.title ?? ''),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              Injector.of(context).authenticationRepository.singOut();

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInView()));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: _bodyContainer(),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget _bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;
    String slogan;
    switch (selectedPos) {
      case 0:
        slogan = "seguridad";

        return buildAccidentModule(context, selectedColor);
      case 1:
        slogan = "Find, Check, Use";
        selectedColor;
        return Container(
          color: selectedColor,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity, // Ocupa el ancho de la pantalla
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiskPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor
                        .withOpacity(0.8), // Color ligeramente más claro
                  ),
                  child: const Text('Inicio de Analisis de riesgo'),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'En esta sección usted puede cargar los accidentes. Debes tener en cuenta que la información debe reflejar todo lo que tienes evidencia',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Establecer el color de texto
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case 2:
        slogan = "Receive, Review, Rip";
        break;
      case 3:
        slogan = "Noise, Panic, Ignore";
        break;
      default:
        slogan = "";
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(
          child: Text(
            slogan,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
