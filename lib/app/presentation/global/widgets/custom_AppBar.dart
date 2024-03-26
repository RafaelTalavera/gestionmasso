import 'package:flutter/material.dart';

import '../../modules/home/views/home_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleWidget;

  const CustomAppBar({Key? key, required this.titleWidget}) : super(key: key);

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
