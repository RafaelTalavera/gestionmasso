import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../main.dart';

import '../../../global/widgets/custom_drawer.dart';
import '../../extinguisher/views/extimguisher_notification.dart';
import '../../sign_in/sign_in_view.dart';
import '../sources/build_configurations_module.dart';
import '../sources/build_environment_module.dart';
import '../sources/build_safety_module.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.warning,
      "Seguridad",
      Colors.teal.shade50,
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      CupertinoIcons.leaf_arrow_circlepath,
      "Ambiente",
      Colors.teal.shade50,
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      CupertinoIcons.book,
      "Referencia",
      Colors.teal.shade50,
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
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

    // Llamar a fetchDataAndNotify al iniciar la pantalla
    fetchDataAndNotify();
  }

  Future<void> fetchDataAndNotify() async {
    // Lógica para obtener datos y enviar notificaciones
    // Crear una instancia de GlobalKey<NavigatorState>
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // Crear una instancia de DataFetcher y pasar navigatorKey como argumento
    DataFetcher dataFetcher = DataFetcher(navigatorKey);

    // Llamar fetchDataAndNotify
    await dataFetcher.fetchDataAndNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
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
              Injector.of(context, listen: false)
                  .authenticationRepository
                  .singOut();

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
        return buildEnviromentModule(context, selectedColor);

      case 2:
        return ConfigurationModule(selectedColor: selectedColor);

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
