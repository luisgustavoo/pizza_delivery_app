import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  bool showLoader;
  String error;
  bool loginSuccess;
  final _authRepository = AuthRepository();

  Future<void> login(String email, String password) async {
    showLoader = true;
    loginSuccess = false;
    error = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(email, password);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('user', user.toJson());
      showLoader = false;
      loginSuccess = true;
    } on RestException catch (e) {
      error = e.message;
      showLoader = false;
    } catch (e) {
      print(e);
      error = 'Erro ao autenticar o usuário';
      showLoader = false;
    } finally {
      notifyListeners();
    }
  }
}
