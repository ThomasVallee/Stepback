import 'package:stepback/src/presentation/ai_reimagine_page/ai_reimagine_page.dart';
import 'package:stepback/src/presentation/ar_screen/ar_screen_page.dart';
import 'package:flutter/material.dart';


class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ARScreenView.routeName:
        return MaterialPageRoute(builder: (_) => const ARScreenView());
      case AIReimaginePage.routeName:
        return MaterialPageRoute(builder: (_) => const AIReimaginePage());
      default:
        return MaterialPageRoute(builder: (_) => const ARScreenView());
    }
  }
}
