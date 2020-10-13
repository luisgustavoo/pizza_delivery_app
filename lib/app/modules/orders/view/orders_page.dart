import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/models/order_model.dart';
import 'package:pizza_delivery_app/app/modules/orders/controller/orders_controller.dart';
import 'package:pizza_delivery_app/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery_app/app/shared/mixins/message_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with LoaderMixin, MessageMixin {
  final formatNumberPrice =
      NumberFormat.currency(name: 'R\$', locale: 'pt-BR', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<OrdersController>().findAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () => context.read<OrdersController>().findAll(),
      child: Consumer<OrdersController>(
        builder: (_, controller, __) {
          showHideLoaderHelper(context, conditional: controller.showLoader);

          if (!isNull(controller.error)) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                      'Erro ao buscar pedidos, tente novamente mais tarde'),
                ),
                RaisedButton(
                  onPressed: () {
                    controller.findAll();
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: controller?.orders?.length ?? 0,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return ExpansionTile(
                title: Text('Pedido ${order.id}'),
                children: [
                  const Divider(),
                  ...order.items.map((o) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(o?.item?.name ?? ''),
                          Text(formatNumberPrice.format(o.item.price))
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(_calculateTotalOrder(order)),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    ));
  }

  String _calculateTotalOrder(OrderModel order) {
    final totalOrder = order.items.fold(
        0.0, (totalValue, orderItems) => totalValue += orderItems.item.price);
    return formatNumberPrice.format(totalOrder);
  }
}
