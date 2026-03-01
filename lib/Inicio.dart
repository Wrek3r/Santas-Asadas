import 'package:flutter/material.dart';

import 'Menu.dart';

class Inicio extends StatefulWidget {
   Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration:  BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    image: DecorationImage(
                      image: AssetImage('assets/IMG1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 30),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color:  Color(0xFF991B1B),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child:  Center(
                        child: FilledButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Menu()),
                          );
                        },
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF991B1B),
                          ),
                          child:  Text(
                          'Ver Menú',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        )
                      ),
                    ),
                  ),
                   SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color:  Color(0xFFFBC02D),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child:  Center(
                        child: Text(
                          'Pedido',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 40),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Destacados',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
             SizedBox(height: 15),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Destacados('assets/Destacado1.jpg', 'Paquete Familiar', '355')),
                   SizedBox(width: 20),
                  Expanded(child: Destacados('assets/Destacado2.jpg', 'Paquete Individual', '75')),
                ],
              ),
            ),
             SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget Destacados(String imagen, String titulo, String precio) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration:  BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Image.asset(
              imagen,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>  Center(child: Icon(Icons.restaurant)),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 80, color: Colors.grey[300]),
                Text(
                  '$titulo\n\$$precio',
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
