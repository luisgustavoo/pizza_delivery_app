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
      if (mounted) {
        context.read<ShoppingCartController>().loadPage();

        controller.addListener(() async {
          showHideLoaderHelper(context, conditional: controller.showLoading);

          if (!isNull(controller.error)) {
            showError(context: context, message: controller.error);
          }

          if (controller.success) {
            showSuccess(
                context: context, message: 'Pedido realizado com sucesso');
            Future.delayed(const Duration(seconds: 1), () {
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
                        title: const Text('Nome'),
                        subtitle: Text('${controller?.user?.name ?? ''}'),
                      ),
                      const Divider(),
                      _buildShoppingCartItems(context, controller),
                      const Divider(),
                      ListTile(
                        title: const Text('Endereço de entrega'),
                        subtitle: Text(controller.address ?? ''),
                        trailing: FlatButton(
                          onPressed: changeAddress,
                          child: Text(
                            'alterar',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Tipo de pagamento'),
                        subtitle: Text(controller.paymentType ?? ''),
                        trailing: FlatButton(
                          onPressed: changePaymentType,
                          child: Text(
                            'alterar',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      const Divider(),
                      //Expanded(child: Container()),
                      PizzaDeliveryButton(
                        'Finalizar pedido',
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50.0,
                        buttonColor: Theme.of(context).primaryColor,
                        labelColor: Colors.white,
                        labelSize: 18,
                        onPressed: () => controller.checkout(),
                      ),
                      const SizedBox(height: 20)
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
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Pedido',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        ...items.map<ShoppingCartItem>((i) => ShoppingCartItem(i)).toList(),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total'),
              Text('${formatNumber.format(controller?.totalPrice ?? 0.0)}')
            ],
          ),
        ),
        const Divider(),
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
        children: const [
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
        title: const Text('Endereço de Entrega'),
        content: TextField(
          controller: addressEditingController,
        ),
        actions: [
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          RaisedButton(
            onPressed: () {
              context
                  .read<ShoppingCartController>()
                  .changeAddress(addressEditingController.text);
              Navigator.pop(context);
            },
            child: const Text('Alterar'),
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
            title: const Text('Tipo de Pagamento'),
            content: Container(
              height: 150,
              child: ValueListenableBuilder(
                valueListenable: paymentTypeSelected,
                builder: (_, paymentTypeSelectedValue, __) {
                  return RadioButtonGroup(
                    picked: paymentTypeSelectedValue as String,
                    labels: const [
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
                child: const Text('Cancelar'),
              ),
              RaisedButton(
                onPressed: () {
                  context
                      .read<ShoppingCartController>()
                      .changePaymentType(paymentTypeSelected.value);
                  Navigator.pop(context);
                },
                child: const Text('Alterar'),
              )
            ],
          );
        });
  }
}
