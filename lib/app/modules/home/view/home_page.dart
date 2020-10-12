import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery_app/app/modules/home/controllers/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/controller/menu_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/view/menu_page.dart';
import 'package:pizza_delivery_app/app/modules/orders/controller/orders_controller.dart';
import 'package:pizza_delivery_app/app/modules/orders/view/orders_page.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/view/shopping_cart.dart';
import 'package:pizza_delivery_app/app/modules/splahs/view/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  static const router = '/home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  HomeController controller;
  final _titles = [
    'Cardápio',
    'Meus Pedidos',
    'Carrinho de Compra',
    'Configurações'
  ];
  final _tabSelected = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: _tabSelected,
            builder: (_, _tabSelectedValue, __) {
              return Text('${_titles[_tabSelectedValue]}');
            }),
        centerTitle: true,
      ),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuController()..findMenu(),
            ),
            ChangeNotifierProvider(create: (_) => OrdersController()),
            ChangeNotifierProvider(create: (_) => ShoppingCartController()),
          ],
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: [
              MenuPage(),
              OrdersPage(),
              ShoppingCart(),
              FlatButton(
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    sp.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SplashPage.router, (route) => false);
                  },
                  child: Text(
                    'Sair',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: controller.bottomNavigationKey,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        items: <Widget>[
          Image.asset('assets/images/logo.png', width: 30),
          Icon(FontAwesome.list),
          Icon(FontAwesome.shopping_cart),
          Icon(Icons.settings),
        ],
        onTap: (index) {
          controller.tabController.animateTo(index);
          _tabSelected.value = index;
          //controller.changePage(index);
        },
      ),
    );
  }
}
