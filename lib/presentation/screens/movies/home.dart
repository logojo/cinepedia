import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

import 'package:cinemapedia/presentation/views/views.dart';

class Home extends StatelessWidget {
  static const name = 'home';
  final int pageIndex;

  const Home({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(), // categoriasView
    FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomButtomNavigation(currentIndex: pageIndex),
    );
  }
}
