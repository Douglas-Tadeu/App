import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';
import 'pages/usuario/usuario_list_page.dart';
import 'pages/usuario/usuario_form_page.dart';
import 'pages/pratos/prato_list_page.dart';
import 'pages/favoritos/favoritos_usuario_page.dart';
import 'services/food_travel_service.dart';
import 'models/prato.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Travel',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/usuarios': (context) => const UsuarioListPage(),
        '/favoritos': (context) => const FavoritosUsuarioPage(),
        '/usuario-form': (context) => const UsuarioFormPage(),
        '/pratos': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final service = FoodTravelService();
          if (args is List<Prato>) {
            return PratoListPage(service: service, initialPratos: args);
          }
          return PratoListPage(service: service);
        },
      },
    );
  }
}
