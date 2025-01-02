import 'package:frontend/data/dio/dio.dart';

class authUser {
  Future<bool> Login(String username, String password) async {
    try {
      final response = await dio.post('login', data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }

    } catch (error) {
      print('Erro ao fazer login $error');
      return false;
    }
  }
}