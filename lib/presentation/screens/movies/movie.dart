import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  static const name = 'movie';

  final String movieId;

  const Movie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MovieID: $movieId')),
    );
  }
}
