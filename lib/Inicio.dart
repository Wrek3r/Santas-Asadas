import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
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
                        child: Text(
                          'Ver Menú',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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
                children: [
                  _Carta1(),
                   SizedBox(width: 20),
                  _Carta2()
                ],
              ),
            ),
             SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _Carta1() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black45, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/Destacado1.jpg',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15,
                    width: 300,
                    color: Colors.red[300],
                    child: Text("Paquete familiar")
                  ),
                   SizedBox(height: 10),
                   Text(
                    '\$285',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
      ),
    );
  }
  Widget _Carta2() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black45, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/Destacado2.jpg',
              height: 120,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 15,
                      width: 300,
                      color: Colors.red[300],
                      child: Text("Paquete Individual")
                  ),
                   SizedBox(height: 10),
                   Text(
                    '\$75',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
      ),
    );
  }
}