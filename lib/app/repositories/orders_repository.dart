import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/order_model.dart';
import 'package:pizza_delivery_app/app/view_models/checkout_input_model.dart';

class OrdersRepository {
  Future<List<OrderModel>> findMyOrders(int userId) async {
    try {
      final result =
          await Dio().get('http://192.168.0.5:8888/order/user/$userId');

      List<Map<String, dynamic>> menuList;

      menuList.add(result as Map<String, dynamic>);

      return menuList.map<OrderModel>((m) => OrderModel.fromMap(m)).toList();

      //return result.data.map<OrderModel>((o) => OrderModel.fromMap(o)).toList();
    } on DioError catch (e) {
      print(e);
      throw RestException('Erro ao buscar pedidos');
    }
  }

  Future<void> checkout(CheckoutInputModel inputModel) async {
    try {
      await Dio().post('http://192.168.0.5:8888/order', data: inputModel.toMap());
    } on DioError catch (e) {
      print(e);
      throw RestException('Erro ao registrar pedido');
    }
  }
}
