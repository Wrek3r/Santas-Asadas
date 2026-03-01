import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
   Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding:  EdgeInsets.only(left: 10.0),
          child: Container(
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon:  Icon(Icons.menu, color: Colors.black, size: 40),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding:  EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:  EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Categoria('Todos', false),
                  Categoria('Paquetes', true),
                  Categoria('Res', false),
                  Categoria('Arrachera', false),
                  Categoria('Tasajo', false),
                ],
              ),
            ),
          ),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding:  EdgeInsets.all(20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.65,
              children: [
                Paquetes('assets/Destacado1.jpg',"Paquete Individual", "\105"),
                Paquetes('assets/Destacado2.jpg',"Paquete 1", "\180"),
                Paquetes('assets/Paquete3.jpg',"Paquete 2", "\210"),
                Paquetes('assets/Menu4.jpg',"Paquete 3", "\330"),
                Paquetes('assets/Destacado1.jpg',"Paquete Familiar", "\355"),

          ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Categoria(String titulo, bool seleccionado) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 4),
      padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: seleccionado ?  Color(0xFF991B1B) :  Color(0xFFFBC02D),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        titulo,
        style: TextStyle(
          color: seleccionado ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget Paquetes(String imagen, String titulo, String precio) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration:  BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
              ),
              child: Image.asset(
                imagen,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>  Center(child: Icon(Icons.restaurant)),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(height: 12, width: 80, color: Colors.grey[300]),
                 Text(
                 '\ $titulo \n '
                  '\$$precio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                 SizedBox(height: 10),
                Container(
                  padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color:  Color(0xFFFBC02D),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child:  Text(
                    'Ver',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
