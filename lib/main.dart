import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

//la classe main se hace asincrina para poder utilizar el paquete flutter_dotenv
// Y poder leer las variables de entorno
Future<void> main() async {
  //realizando la carga de todas las variables de entorno del archivo .env
  await dotenv.load(fileName: ".env");

  runApp(
      //implementacion de riverpod provider
      const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    //importacion de rutas
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
