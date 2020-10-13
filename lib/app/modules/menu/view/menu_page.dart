import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';
import 'package:pizza_delivery_app/app/modules/home/controllers/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/controller/menu_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<ShoppingCartController>(
        builder: (_, controller, __) {
          if(controller.hasItemSelected){
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<HomeController>().changePage(2);
              },
              label: const Text('Finalizar Pedido'),
              icon: const Icon(Icons.monetization_on),
              backgroundColor: Theme.of(context).primaryColor,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/topoCardapio.png'),
                        fit: BoxFit.none)),
              ),
              Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Consumer<MenuController>(builder: (_, controller, __) {
      if (controller.showLoader) {
        return const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (!isNull(controller.error)) {
        return Text(controller.error);
      }

      final menu = controller.menu;

      return Column(
        children: [
          ...menu.map<Widget>((m) {
            return _buildGroup(context, m.name, m.items);
          }).toList(),
          const SizedBox(height: 50,)
        ]
      );

    });
  }

  Widget _buildGroup(
      BuildContext context, String name, List<MenuItemModel> items) {
    final formatNumber = NumberFormat('###.00', 'pt-BR');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final mi = items[index];
            return ListTile(
              title: Text(
                mi.name,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text('R\$ ${formatNumber.format(mi.price)}'),
              trailing: Consumer<ShoppingCartController>(
                builder: (_, controllerShoppingCart, __) {
                  final itemSelected = controllerShoppingCart.itemSelected(mi);
                  return IconButton(
                    onPressed: () {
                      controllerShoppingCart.addOrRemoveItem(mi);
                    },
                    icon: Icon(
                      itemSelected
                          ? FontAwesome.minus_square
                          : FontAwesome.plus_square,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
