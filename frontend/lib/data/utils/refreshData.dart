import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';

class RefreshData {
  final GetServices getServices = new GetServices();

  Future<int> fetchInsumos() async {
    try { 
      final result = await getServices.getInsumos();

      int countEstoque = result.fold(0, (sum, item) {
        return sum + (item['estoque_minimo'] != null ? item['estoque_minimo'] as int : 0);
      });

      return countEstoque;

    } catch (error) {
      debugPrint('Erro ao carregar insumos: $error');
      return 0;
    }
  }
}