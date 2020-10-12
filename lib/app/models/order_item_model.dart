import 'dart:convert';

import 'package:pizza_delivery_app/app/models/menu_item_model.dart';

class OrderItemModel {
  OrderItemModel({
    this.id,
    this.item,
  });

  final int id;
  final MenuItemModel item;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item?.toMap(),
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderItemModel(
      id: map['id'],
      item: MenuItemModel.fromMap(map['item']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(json.decode(source));
}
