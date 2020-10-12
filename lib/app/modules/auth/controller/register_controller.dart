import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/repositories/auth_repository.dart';
import 'package:pizza_delivery_app/app/view_models/register_input_model.dart';

class RegisterController extends ChangeNotifier {
  bool showLoader;
  String error;
  bool registerSuccess;
  final _authRepository = AuthRepository();

  Future<void> registerUser(String name, String email, String password) async {
    showLoader = true;
    registerSuccess = false;
    error = null;
    notifyListeners();

    final inputModel =
        RegisterInputModel(name: name, email: email, password: password);

    try {
      await _authRepository.saveUser(inputModel);
      showLoader = false;
      registerSuccess = true;
    } on RestException catch (e) {
      print(e);
      registerSuccess = false;
      error = e.message;
    } finally {
      showLoader = false;
      notifyListeners();
    }
  }
}
