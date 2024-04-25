// ignore: file_names
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Icon,
        IconButton,
        Icons,
        Image,
        MaterialPageRoute,
        Navigator,
        PreferredSizeWidget,
        Row,
        Size,
        SizedBox,
        StatelessWidget,
        Widget,
        kToolbarHeight;

import '../../modules/home/views/home_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.titleWidget,
  });
  final Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/imagen/gmasso.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10),
          titleWidget,
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false, // Elimina todas las rutas anteriores
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
