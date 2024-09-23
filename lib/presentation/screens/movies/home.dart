import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

import 'package:cinemapedia/presentation/views/views.dart';

class Home extends StatefulWidget {
  static const name = 'home';
  final int pageIndex;

  const Home({super.key, required this.pageIndex});

  @override
  State<Home> createState() => _HomeState();
}

//* AutomaticKeepAliveClientMixin es un Mixin es necesario para mantener el estado en el PageView
//* al usar el AutomaticKeepAliveClientMixin siempre se tiene que sobre escribir el wantKeepAlive
//* y mandar llamar el  super.build(context);
//* AutomaticKeepAliveClientMixin es util cuando los widgets son pesados de reconstruir o tienen mucho estado que no quieres perder
//* y mejora la experiencia de usuario
class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  final viewRoutes = const <Widget>[
    HomeView(),
    PopularesView(),
    FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageController.hasClients) {
      pageController.animateToPage(widget.pageIndex,
          duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    }

    return Scaffold(
      body: PageView(
        //* Esto evitará que rebote
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomButtomNavigation(currentIndex: widget.pageIndex),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
