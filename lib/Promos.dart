import 'package:flutter/material.dart';

class Promos extends StatelessWidget {
  const Promos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97316),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: const Text(
          'Promociones',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Próximamente promociones...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
