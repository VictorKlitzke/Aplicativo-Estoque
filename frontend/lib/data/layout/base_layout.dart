import 'package:flutter/material.dart';
import 'package:frontend/data/components/sideBar_components.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;

  const BaseLayout({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Estoque'),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(child: SideBarComponents()),
          ],
        ),
      ),
      body: body,
    );
  }
}
