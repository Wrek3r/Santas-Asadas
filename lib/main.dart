import 'package:flutter/material.dart';
import 'package:santas_asadas/Chat.dart';
import 'package:santas_asadas/Inicio.dart';
import 'package:santas_asadas/Local.dart';
import 'package:santas_asadas/Menu.dart';
import 'package:santas_asadas/Promos.dart';

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
      home:  Main(),
    );
  }
}

class Main extends StatefulWidget {
  Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _indice = 0;
Widget Pantallas(){
  switch(_indice){
    case 0:
      return Inicio();
    case 1:
      return Menu();
    case 2:
      return Promos();
    case 3:
      return Local();
      case 4:
      return Chat();
    default:
      return Inicio();
  }


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pantallas(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Color(0xFFF58220),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _indice,
        onTap: (index) {
          setState(() => _indice = index);
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menú",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent),
            label: "Promos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Local",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble, size: 30),
              label: 'Chat'),

        ],
      ),

    );

  }
}
