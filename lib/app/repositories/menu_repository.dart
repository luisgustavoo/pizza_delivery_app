import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/menu_model.dart';

class MenuRepository {
  Future<List<MenuModel>> findAll() async {
    try {
      final response = await Dio().get('http://192.168.0.5:8888/menu');

      List<Map<String, dynamic>> menuList;

      menuList.add(response as Map<String, dynamic>);

      return menuList.map<MenuModel>((m) => MenuModel.fromMap(m)).toList();

      //return response.data.map<MenuModel>( (m) => MenuModel.fromMap(m)).toList();
    } on DioError catch (e) {
      print(e);
      throw RestException('Erro ao buscar cardápio');
    }
  }
}
