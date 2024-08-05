import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  Stream<String> getLoadigMessages() {
    final messages = <String>[
      'Cargando peliculas',
      'Compra palomitas',
      'Cargando populares',
      'LLamando a wendy',
      'Ya merito',
      'Esto esta tardando demaciado'
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadigMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
