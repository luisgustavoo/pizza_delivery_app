import 'dart:convert';

import 'package:pizza_delivery_app/app/models/menu_item_model.dart';

class OrderItemModel {
  OrderItemModel({
    this.id,
    this.item,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return OrderItemModel(
      id: map['id'] as int,
      item: MenuItemModel.fromMap(map['item'] as Map<String, dynamic>),
    );
  }

  final int id;
  final MenuItemModel item;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item?.toMap(),
    };
  }


  String toJson() => json.encode(toMap());

}
