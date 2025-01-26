import 'package:frontend/data/dio/dio.dart';

class PostServices {
  Future<bool> RegisterInsumos(data) async {
    try {
      final response = await dio.post('registerinsumos', data: {'data': data});

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> RegisterMovimentacoes(data) async {
    try {
      final response = await dio.post('registermovimentacoes', data: {'data': data});

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

class GetServices {
  Future<List<Map<String, dynamic>>> getInsumos() async {
    try {
      final response = await dio.get('getInsumos');
      if (response.data != null || response.data['getInsumos'] != null) {
        return List<Map<String, dynamic>>.from(response.data['getInsumos']);
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
