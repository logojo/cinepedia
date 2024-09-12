import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

class Home extends StatelessWidget {
  static const name = 'home';
  final Widget childview;

  const Home({super.key, required this.childview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childview,
      bottomNavigationBar: const CustomButtomNavigation(),
    );
  }
}
