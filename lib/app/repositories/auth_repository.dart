import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/user_model.dart';
import 'package:pizza_delivery_app/app/view_models/register_input_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await Dio().post('http://192.168.0.5:8888/user/auth',
          data: {'email': email, 'password': password});

      return UserModel.fromMap(response.data);
    } on DioError catch (e) {
      print(e);
      String message = 'Erro ao autenticar o usuário';
      if (e?.response?.statusCode == 403) {
        message = 'Usuário ou senha iválidos';
      }
      throw RestException(message);
    }
  }

  Future<void> saveUser(RegisterInputModel registerInputModel) async {
    try {
      await Dio().post('http://192.168.0.5:8888/user', data: {
        'name': registerInputModel.name,
        'email': registerInputModel.email,
        'password': registerInputModel.password
      });
    } on DioError catch (e) {
      print(e);
      throw RestException('Erro ao registrar usuário');
    }
  }
}
