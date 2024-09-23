import 'package:cinemapedia/config/helpers/number_formats.dart';
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {
  final double voteAverage;

  const MovieRating({super.key, required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
          const SizedBox(width: 3),
          Text(NumberFormats.number(voteAverage, 1))
        ],
      ),
    );
  }
}
