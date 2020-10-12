import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/modules/home/controllers/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/components/shopping_cart_item.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:pizza_delivery_app/app/shared/componets/pizza_delivery_button.dart';
import 'package:pizza_delivery_app/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery_app/app/shared/mixins/message_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>
    with MessageMixin, LoaderMixin {
  final formatNumber =
      NumberFormat.currency(name: 'R\$', locale: 'pt_BR', decimalDigits: 2);
  final addressEditingController = TextEditingController();
  final paymentTypeSelected = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final controller = context.read<ShoppingCartController>();
      if (this.mounted) {
        context.read<ShoppingCartController>().loadPage();

        controller.addListener(() async {
          showHideLoaderHelper(context, controller.showLoading);

          if (!isNull(controller.error)) {
            showError(context: context, message: controller.error);
          }

          if (controller.success) {
            showSuccess(context: context, message: 'Pedido realizado com sucesso');
            Future.delayed(Duration(seconds: 1), () {
              controller.clearShoppingCart();
              context.read<HomeController>().changePage(1);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ShoppingCartController>(
        builder: (_, controller, __) {
          return SingleChildScrollView(
            child: !controller.hasItemSelected
                ? _buildClearShoppingCart(context)
                : Column(
                    children: [
                      ListTile(
                        title: Text('Nome'),
                        subtitle: Text('${controller?.user?.name ?? ''}'),
                      ),
                      Divider(),
                      _buildShoppingCartItems(context, controller),
                      Divider(),
                      ListTile(
                        title: Text('Endereço de entrega'),
                        subtitle: Text(controller.address ?? ''),
                        trailing: FlatButton(
                          onPressed: () => changeAddress(),
                          child: Text(
                            'alterar',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Tipo de pagamento'),
                        subtitle: Text(controller.paymentType ?? ''),
                        trailing: FlatButton(
                          onPressed: () => changePaymentType(),
                          child: Text(
                            'alterar',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Divider(),
                      //Expanded(child: Container()),
                      PizzaDeliveryButton(
                        'Finaliza pedido',
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50.0,
                        buttonColor: Theme.of(context).primaryColor,
                        labelColor: Colors.white,
                        labelSize: 18,
                        onPressed: () => controller.checkout(),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildShoppingCartItems(
      BuildContext context, ShoppingCartController controller) {
    final items = controller.itemsSelected.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Pedido',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        ...items.map<ShoppingCartItem>((i) => ShoppingCartItem(i)).toList(),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total'),
              Text('${formatNumber.format(controller?.totalPrice ?? 0.0)}')
            ],
          ),
        ),
        Divider(),
        FlatButton(
            onPressed: () => controller.clearShoppingCart(),
            child: Text('Limpar carrinho',
                style: TextStyle(color: Theme.of(context).primaryColor))),
      ],
    );
  }

  Widget _buildClearShoppingCart(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(AntDesign.shoppingcart, size: 200),
          Text('Seu carrinho está vazio'),
        ],
      ),
    );
  }

  void changeAddress() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Endereço de Entrega'),
        content: TextField(
          controller: addressEditingController,
        ),
        actions: [
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          RaisedButton(
            onPressed: () {
              context
                  .read<ShoppingCartController>()
                  .changeAddress(addressEditingController.text);
              Navigator.pop(context);
            },
            child: Text('Alterar'),
          )
        ],
      ),
    );
  }

  void changePaymentType() {
    showDialog(
        context: context,
        builder: (_) {
          final controller = context.read<ShoppingCartController>();
          paymentTypeSelected.value = controller.paymentType;
          return AlertDialog(
            title: Text('Tipo de Pagamento'),
            content: Container(
              height: 150,
              child: ValueListenableBuilder(
                valueListenable: paymentTypeSelected,
                builder: (_, paymentTypeSelectedValue, __) {
                  return RadioButtonGroup(
                    picked: paymentTypeSelectedValue,
                    labels: <String>[
                      'Cartão de Crédito',
                      'Cartão de Debito',
                      'Dinheiro'
                    ],
                    onSelected: (selected) {
                      paymentTypeSelected.value = selected;
                    },
                  );
                },
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              RaisedButton(
                onPressed: () {
                  context
                      .read<ShoppingCartController>()
                      .changePaymentType(paymentTypeSelected.value);
                  Navigator.pop(context);
                },
                child: Text('Alterar'),
              )
            ],
          );
        });
  }
}
