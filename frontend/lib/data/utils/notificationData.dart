import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/data/services/api_services.dart';
import 'package:frontend/data/dio/dio.dart';

class NotificationData {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GetServices getServices = new GetServices();

  NotificationData({required this.flutterLocalNotificationsPlugin});

  Future<void> NotificationMessge(String title, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'stock_channel',
      'Stock Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      notificationDetails,
    );
  }

  Future<List<Map<String, dynamic>>?> ListInsumos() async {
    try {
      final insumos = await getServices.getInsumos();

      final estoqueBaixo = insumos.where((item) {
        return item['estoque_minimo'] <= 20;
      }).toList();

      if (estoqueBaixo.isNotEmpty) {
        for(var item in estoqueBaixo) {
          await NotificationMessge(
            'Estoque Crítico',
            'O item ${item['nome']} está com estoque baixo (${item['estoque_minimo']}).',
          );
        }
      }
      return estoqueBaixo;
    } catch (error) {
      print('Erro ao listar insumos: $error');
      return [];
    }
  }
}
