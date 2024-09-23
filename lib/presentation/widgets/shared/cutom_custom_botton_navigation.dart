import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomButtomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (value) => context.go("/home/$value"),
        selectedItemColor: colors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.thumbs_up_down_outlined), label: 'Pupulares'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favoritos')
        ]);
  }
}
