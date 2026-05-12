import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santas_asadas/Chat.dart';
import 'package:santas_asadas/Inicio.dart';
import 'package:santas_asadas/Local.dart';
import 'package:santas_asadas/Menu.dart';
import 'package:santas_asadas/Promos.dart';
import 'package:santas_asadas/Login.dart';
import 'providers/CartProvider.dart';
import 'database_helper.dart';
import 'jwt_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({super.key});
  Future<Widget> _resolverPantalla() async {
    final token = await DatabaseHelper.instance.obtenerToken();

    if (token == null || JwtHelper.tokenExpirado(token)) {
      await DatabaseHelper.instance.cerrarSesion();
      return Login();
    }

    return Main();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Santas Asadas',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF97316),
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFFF97316),
            onPrimary: Colors.white,
            secondary: const Color(0xFFFBC02D),
            onSecondary: Colors.black87,
            error: const Color(0xFF991B1B),
            surface: Colors.white,
            onSurface: const Color(0xFF1A1A1A),
          ),
          textTheme: const TextTheme(
            displaySmall: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5, color: Colors.black87),
            headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
            headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
            titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black54),
            bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black54),
            labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5, color: Colors.black87),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: Colors.black12,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              elevation: 2,
              shadowColor: Colors.black26,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              side: BorderSide(color: Color(0xFFF97316), width: 1.5),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black26),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black38, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFF97316), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF991B1B), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF991B1B), width: 2),
            ),
            prefixIconColor: Colors.black54,
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w400),
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shadowColor: Colors.black12,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          chipTheme: const ChipThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            selectedColor: Colors.orangeAccent,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          dialogTheme: const DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 8,
          ),
        ),
        home:  FutureBuilder<Widget>(
          future: _resolverPantalla(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFF97316)),
            ),
          );
        }
        return snapshot.data!;
      },
    ),
        routes: {
          '/menu': (context) => Menu(),
          '/chat': (context) => Chat(),
          '/inicio': (context) => Inicio(),
          '/local': (context) => Local(),
          '/promos': (context) => Promos(),
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  Main({super.key});

  static _MainState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainState>();

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

  final List<Widget> _pantallas = [Inicio(), Menu(), Promos(), Local(), Chat()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF97316), Color(0xFFFF6B00)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/Logo.png',
                          height: 56,
                          errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, size: 36, color: Color(0xFFF97316)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Santas Asadas',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Menu & Pedidos',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(Icons.person_outline, 'Mi Perfil', () {}),
            _buildDrawerItem(Icons.receipt_long_outlined, 'Mis Pedidos', () {}),
            _buildDrawerItem(Icons.favorite_outline, 'Favoritos', () {}),
            _buildDrawerItem(Icons.notifications_none_outlined, 'Notificaciones', () {}),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(thickness: 1),
            ),
            _buildDrawerItem(Icons.settings_outlined, 'Configuración', () {}),
            _buildDrawerItem(Icons.help_outline, 'Ayuda y Soporte', () {}),
            _buildDrawerItem(Icons.logout, 'Cerrar Sesión', () async {
              await DatabaseHelper.instance.cerrarSesion();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                      (route) => false,
                );
              }
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: _pantallas[_indice],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.orangeAccent.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black12,
        selectedIndex: _indice,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) {
          setState(() => _indice = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home, color: Colors.orangeAccent),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.restaurant_menu, color: Colors.orangeAccent),
            label: 'Menú',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.local_offer, color: Colors.orangeAccent),
            label: 'Promos',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.location_on, color: Colors.orangeAccent),
            label: 'Local',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.orangeAccent),
            label: 'Chat',
          ),
        ],
      ),
    );

  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 12,
      onTap: onTap,
    );
  }

}
