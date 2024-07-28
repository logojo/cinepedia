import 'package:cinemapedia/config/constants/environments.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const name = 'home';

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Environments.movieDbKey),
      ),
    );
  }
}
