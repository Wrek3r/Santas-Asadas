import 'package:flutter/material.dart';
import 'package:santas_asadas/Inicio.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Santas Asadas',
      theme: ThemeData(
        scaffoldBackgroundColor:  Color(0xFFF58220),
        useMaterial3: true,
      ),
      home:  Inicio(),
    );
  }
}


