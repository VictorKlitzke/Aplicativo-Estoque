import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/data/dio/dio.dart';
import 'package:frontend/data/layout/base_layout.dart';
import 'package:frontend/data/pages/home_page.dart';
import 'package:frontend/data/pages/login_page.dart';
import 'package:frontend/data/pages/movimentacoes_page.dart';
import 'package:frontend/data/pages/registerinsumos_page.dart';
import 'package:frontend/data/utils/notificationData.dart';

void main () {
  configureDio();
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estoque Insumos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white70),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home' : (context) => BaseLayout(body: HomePage(
          notificationData: NotificationData(
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          ),
        )),
        '/Insumos' : (context) => BaseLayout(body: RegisterInsumosPage()),
        '/Reposicao' : (context) => BaseLayout(body: MovimentacoesPage())
      },
    );
  }
}