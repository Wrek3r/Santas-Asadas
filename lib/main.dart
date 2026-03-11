import 'package:flutter/material.dart';
import 'package:santas_asadas/Chat.dart';
import 'package:santas_asadas/Inicio.dart';
import 'package:santas_asadas/Local.dart';
import 'package:santas_asadas/Menu.dart';
import 'package:santas_asadas/Promos.dart';
import 'package:santas_asadas/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Santas Asadas',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF58220),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  static _MainState? of(BuildContext context) => context.findAncestorStateOfType<_MainState>();

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _indice = 0;

  @override
  void initState() {
    super.initState();
  }

  void cambiarIndice(int nuevoIndice) {
    setState(() {
      _indice = nuevoIndice;
    });
  }

  final List<Widget> _pantallas = [
    const Inicio(),
    const Menu(),
    const Promos(),
    const Local(),
    const Chat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF58220),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF991B1B),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/Logo.png',),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Santas Asadas',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.person, 'Mi Perfil', () {}),
              _buildDrawerItem(Icons.history, 'Mis Pedidos', () {}),
              _buildDrawerItem(Icons.favorite, 'Favoritos', () {}),
              _buildDrawerItem(Icons.notifications, 'Notificaciones', () {}),
              const Divider(color: Colors.black26),
              _buildDrawerItem(Icons.settings, 'Configuración', () {}),
              _buildDrawerItem(Icons.help, 'Ayuda y Soporte', () {}),
              _buildDrawerItem(Icons.logout, 'Cerrar Sesión', () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              }),
            ],
          ),
        ),
      ),
      body: _pantallas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF58220),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _indice,
        onTap: (index) {
          setState(() => _indice = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Menú"),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: "Promos"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Local"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }
}
