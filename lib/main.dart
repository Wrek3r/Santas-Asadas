import 'package:flutter/material.dart';
import 'package:santas_asadas/Inicio.dart';
import 'package:santas_asadas/Menu.dart';
import 'package:santas_asadas/Promos.dart';
import 'package:santas_asadas/Local.dart';
import 'package:santas_asadas/Chat.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Santas Asadas',
      theme: ThemeData(
        scaffoldBackgroundColor:  Color(0xFFF58220),
        useMaterial3: true,
      ),
      home:  MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
   const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indice = 0;

  final List<Widget> _pantallas = [
     Inicio(),
     Menu(),
    const Promos(),
    const Local(),
    const Chat(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indice = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Color(0xFFF58220),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _indice,
        onTap: _onItemTapped,
        selectedLabelStyle:  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle:  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu, size: 30), label: 'Menú'),
          BottomNavigationBarItem(icon: Icon(Icons.percent, size: 30), label: 'Promos'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on, size: 30), label: 'Local'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble, size: 30), label: 'Chat'),
        ],
      ),
    );
  }
}
