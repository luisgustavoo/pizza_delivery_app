import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/models/menu_model.dart';
import 'package:pizza_delivery_app/app/repositories/menu_repository.dart';

class MenuController extends ChangeNotifier {
  final _repository = MenuRepository();
  List<MenuModel> menu = [];
  bool showLoader = false;
  String error;

  Future<void> findMenu() async {
    showLoader = true;
    error = null;
    notifyListeners();
    try {
      menu = await _repository.findAll();
    } catch (e) {
      print(e);
      error = 'Erro ao buscar cardápio';
    } finally {
      showLoader = false;
      notifyListeners();
    }
  }
}
