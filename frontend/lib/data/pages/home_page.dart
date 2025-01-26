import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';
import 'package:frontend/data/utils/notificationData.dart';
import 'package:frontend/data/utils/refreshData.dart';
class HomePage extends StatefulWidget {
  final NotificationData notificationData;

  const HomePage({super.key, required this.notificationData});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final RefreshData _refreshData = new RefreshData();

  bool isLoading = false;
  int estoqueMinimo = 0;
  List<Map<String, dynamic>> itensCriticos = [];

  @override
  void initState() {
    super.initState();
    refresh();
    notification();
  }
  Future<void> refresh() async {
    setState(() {
      isLoading = true;
    });
    final result = await _refreshData.fetchInsumos();
    setState(() {
      estoqueMinimo = result;
      isLoading = false;
    });
  }

  Future<void> notification() async {
    setState(() {
      isLoading = true;
    });

    final result = await widget.notificationData.ListInsumos();

    setState(() {
      itensCriticos = result!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Resumo do Estoque',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    title: 'Total de Insumos',
                    value: isLoading ? 'Carregando...' : estoqueMinimo.toString(),
                    icon: Icons.inventory,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Itens Críticos',
                    value: '23',
                    icon: Icons.warning,
                    color: Colors.redAccent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Alertas Recentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                    itemCount: itensCriticos.length,
                    itemBuilder: (Context, index) {
                      final insumo = itensCriticos[index];
                      return _buildAlertCard(
                          message: '${insumo['nome']} está abaixo do estoque mínimo.',
                          date: 'Hoje');
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard({required String message, required String date}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.notification_important, color: Colors.red),
        title: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
