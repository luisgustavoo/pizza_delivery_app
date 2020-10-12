import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/order_model.dart';
import 'package:pizza_delivery_app/app/models/user_model.dart';
import 'package:pizza_delivery_app/app/repositories/orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersController extends ChangeNotifier {
  final _repository = OrdersRepository();
  List<OrderModel> orders = [];
  bool showLoader = false;
  String error;

  Future<void> findAll() async {
    showLoader = true;
    error = null;
    notifyListeners();

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final user = UserModel.fromJson(sp.get('user'));

      orders = await _repository.findMyOrders(user.id);
    } on RestException catch (e) {
      error = e.message;
    } catch (e) {
      throw 'Erro ao buscar pedidos';
    } finally {
      showLoader = false;
      notifyListeners();
    }
  }
}
