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
}
