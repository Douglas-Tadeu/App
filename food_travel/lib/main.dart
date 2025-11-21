import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/food_travel_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FoodTravelService(); // Instância do serviço

    return MaterialApp(
      title: 'Food Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(service: service), // Inicia na tela de login
    );
  }
}
