import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GetServices getServices = GetServices();
  bool isLoading = false;
  int estoqueMinimo = 0;

  @override
  void initState() {
    super.initState();
    fetchInsumos();
  }

  void fetchInsumos() async {
    setState(() {
      isLoading = true;
    });
    try {

      final result = await getServices.getInsumos();
      
      setState(() {
        estoqueMinimo = result.where((item) => item['estoque_minimo'] > 0).length;
      });

      print(' Home $estoqueMinimo');

    } catch (error) {
      print('Erro ao carregar Insumos $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
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
                child: ListView(
                  children: [
                    _buildAlertCard(
                      message: 'Fertilizante X próximo do limite mínimo.',
                      date: 'Hoje',
                    ),
                    _buildAlertCard(
                      message: 'Sementes Y em falta.',
                      date: 'Ontem',
                    ),
                    _buildAlertCard(
                      message: 'Defensivo Z com alta saída neste mês.',
                      date: 'Há 3 dias',
                    ),
                  ],
                ),
              ),
            ],
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
