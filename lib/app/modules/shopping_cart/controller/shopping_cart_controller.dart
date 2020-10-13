import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';
import 'package:pizza_delivery_app/app/models/user_model.dart';
import 'package:pizza_delivery_app/app/repositories/orders_repository.dart';
import 'package:pizza_delivery_app/app/view_models/checkout_input_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class ShoppingCartController extends ChangeNotifier {
  UserModel user;

  Set<MenuItemModel> itemsSelected = {};

  final _repository = OrdersRepository();

  String _address = '';
  String _paymentType = '';
  String _error = '';
  bool _success = false;
  bool _showLoading = false;

  bool get showLoading => _showLoading;

  bool get success => _success;

  String get paymentType => _paymentType;

  String get address => _address;

  String get error => _error;

  Future<void> loadPage() async {
    _error = null;
    _showLoading = true;
    _success = false;
    notifyListeners();

    final sp = await SharedPreferences.getInstance();
    user = UserModel.fromJson(sp.get('user') as String);

    _showLoading = false;
    notifyListeners();
  }

  bool itemSelected(MenuItemModel item) => itemsSelected.contains(item);

  double get totalPrice =>
      itemsSelected.fold(0.0, (total, item) => total += item.price);

  bool get hasItemSelected => itemsSelected.isNotEmpty;

  void addOrRemoveItem(MenuItemModel item) {
    if (itemSelected(item)) {
      _removeItemShoppingCart(item);
    } else {
      _addItemShoppingCart(item);
    }
    notifyListeners();
  }

  void _addItemShoppingCart(MenuItemModel item) {
    itemsSelected.add(item);
    notifyListeners();
  }

  void _removeItemShoppingCart(MenuItemModel item) {
    itemsSelected.remove(item);
    notifyListeners();
  }

  void clearShoppingCart() {
    itemsSelected.clear();
    _address = '';
    _paymentType = '';
    _showLoading = false;
    _error = null;
    _success = false;

    notifyListeners();
  }

  void changeAddress(String newAddress) {
    _error = null;
    _address = newAddress;
    notifyListeners();
  }

  void changePaymentType(String newPaymentType) {
    _error = null;
    _paymentType = newPaymentType;
    notifyListeners();
  }

  void checkout() async {
    _error = null;
    _showLoading = false;
    _success = false;
    notifyListeners();

    if (address.isEmpty || isNull(address)) {
      _error = 'Endereço de entrega obrigatório';
      notifyListeners();
    } else if (paymentType.isEmpty || isNull(paymentType)) {
      _error = 'Tipo de pagamento obrigatório';
      notifyListeners();
    } else {
      _showLoading = true;

      String paymentTypeBackend = '';

      switch (_paymentType) {
        case 'Cartão de Crédito':
          paymentTypeBackend = 'Crédito';
          break;
        case 'Cartão de Debito':
          paymentTypeBackend = 'Debito';
          break;
        default:
          paymentTypeBackend = 'Dinheiro';
      }

      try {
        _showLoading = true;
        notifyListeners();

        await _repository.checkout(CheckoutInputModel(
          userId: user.id,
          address: _address,
          paymentType: paymentTypeBackend,
          itemsId: itemsSelected.map<int>((i) => i.id).toList(),
        ));
        _success = true;
      } catch (e) {
        _error = 'Erro ao registrar pedido';
      } finally {
        _showLoading = false;
        notifyListeners();
      }
    }
  }
}
