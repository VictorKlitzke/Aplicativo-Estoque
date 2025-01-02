import 'package:flutter/material.dart';
import 'package:frontend/data/dio/dio.dart';
import 'package:frontend/data/layout/base_layout.dart';
import 'package:frontend/data/pages/home_page.dart';
import 'package:frontend/data/pages/login_page.dart';
import 'package:frontend/data/pages/registerinsumos_page.dart';

void main () {
  configureDio();
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estoque Insumos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white70),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home' : (context) => BaseLayout(body: HomePage()),
        '/Insumos' : (context) => BaseLayout(body: RegisterInsumosPage())
      },
    );
  }
}